extends Area2D

@export var vertical_speed = 500
@export var explosion_anim_duration_multiplier = 1
@export var lane_y_diff = 80

var move_vector: Vector2
var y_limit := position.y
var joystick_lock_up := false
var joystick_lock_down := false
var original_y_position: float

var dont_collide := false
var dead := false

var explosion_tween: Tween
var death_timer: Timer

@onready var player: AudioStreamPlayer2D = $PickupPlayer

func _ready() -> void:
	SignalBus.reduce_motion.connect(_reduce_motion)
	SignalBus.cr_skin.connect(_set_skin)
	_set_skin()
	if SettingsBus.reduced_motion:
		$LukaszczykWPandzie.stop()
	if owner.version_2:
		original_y_position = position.y
		death_timer = $DeathTimer
		owner.powerup_semaglutide.connect(_powerup_semaglutide_handler)


func _process(delta) -> void:
	position += move_vector * delta * owner.time_scale
	if move_vector.y > 0:
		if position.y >= y_limit:
			position.y = y_limit
			move_vector = Vector2(0,0)
			owner.gui.direction_indicators(owner.gui.TurnModes.OFF)
	elif move_vector.y < 0:
		if position.y <= y_limit:
			position.y = y_limit
			move_vector = Vector2(0,0)
			owner.gui.direction_indicators(owner.gui.TurnModes.OFF)


func _input(event):
	if event.is_action_pressed("move_up"):
		if event is InputEventJoypadMotion:
			if event.get_action_strength("move_up") < SettingsBus.gamepad_deadzone:
				joystick_lock_up = false
				return
			if joystick_lock_up:
				return
			joystick_lock_up = true
		move(true)
	elif event.is_action_pressed("move_down"):
		if event is InputEventJoypadMotion:
			if event.get_action_strength("move_down") < SettingsBus.gamepad_deadzone:
				joystick_lock_down = false
				return
			if joystick_lock_down:
				return
			joystick_lock_down = true
		move(false)
	if event.is_action_released("move_down") and event is InputEventJoypadMotion:
		joystick_lock_down = false
	if event.is_action_released("move_up") and event is InputEventJoypadMotion:
		joystick_lock_up = false
#	elif event is InputEventScreenTouch:
#		if event.pressed and event.index == 0:
#			if event.position.y > (get_viewport().get_visible_rect().size.y / 2):
#				move(false)
#			else:
#				move(true)


func _on_area_entered(area):
	if not dead:
		var ar = area.get_parent()
		if ar.is_in_group("Obstacles"):
			_area_entered_obstacle(ar)
		if ar.is_in_group("Milk"):
			_area_entered_milk(ar)
		if ar.is_in_group("Powerups"):
			_area_entered_powerup(ar)


func _area_entered_obstacle(ar: Node2D):
	_check_if_clean_collision()
	if not dont_collide or ar.is_in_group("OutOfBounds"):
		if not SettingsBus.godmode:
			dead = true
			owner.lives -= 1
			owner.gui.direction_indicators(owner.gui.TurnModes.OFF)
			if owner.version_2:
				owner.gui.hide_one_live()
				owner.powerup = null
			_explode()

			call_deferred("set", "process_mode", Node.PROCESS_MODE_DISABLED)
			if owner.lives <= 0:
				owner.game_over()
			else:
				_respawn()
		$CrashPlayer.play()
		if ar.is_in_group("OutOfBounds"):
			AchievementSystem.call_achievement("offroad")


func _area_entered_milk(ar: Node2D):
	if not dead and _check_if_clean_collision():
		var sfx = ar.get_node("PickableComponent").pickup_sfx
		player.stream = sfx
		player.play()
		ar.queue_free()

		if ar.is_in_group("MilkTriple"):
			owner.milks += 3
		else:
			owner.milks += 1


func _area_entered_powerup(ar: Node2D):
	if not dead and _check_if_clean_collision():
		var sfx = ar.get_node("PickableComponent").pickup_sfx
		player.stream = sfx
		player.play()
		ar.queue_free()

		owner.powerup = ar


func _check_if_clean_collision() -> bool:
	if dont_collide or owner.powerup == PowerupClass.Powerups.MILKYWAY:
		return true
	for raycast in $RayCasts.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			return false
	return true


func _explode():
	$LukaszczykWPandzie.hide()
	if explosion_tween:
		explosion_tween.kill()
	$Explosion.position = Vector2(0,0)
	$Explosion.play()
	explosion_tween = $Explosion.create_tween()
	explosion_tween.tween_property(
			$Explosion,
			"position",
			Vector2.LEFT * owner.speed,
			explosion_anim_duration_multiplier
	)


func _respawn():
	ProfileBus.profile.add_run()
	ProfileBus.profile.add_speed(owner.speed)
	death_timer.start(2)
	await death_timer.timeout
	position = Vector2(position.x, original_y_position)
	y_limit = position.y
	call_deferred("set", "process_mode", Node.PROCESS_MODE_INHERIT)
	owner.speed = owner.original_speed
	$LukaszczykWPandzie.show()
	dead = false

	dont_collide = true
	death_timer.start(1)
	await death_timer.timeout
	dont_collide = false


func move(dir_up: bool):
	if process_mode != Node.PROCESS_MODE_DISABLED:
		move_vector = Vector2(0, (-vertical_speed if dir_up else vertical_speed))
		y_limit += -lane_y_diff if dir_up else lane_y_diff
		var mode = owner.gui.TurnModes.LEFT if dir_up else owner.gui.TurnModes.RIGHT
		owner.gui.direction_indicators(mode)


func _powerup_semaglutide_handler(yes: bool):
	if yes and scale == Vector2(1.5, 1.5):
		scale = Vector2(0.5, 0.5)
		y_limit -= -20
		position -= Vector2(0, -20)
	elif scale == Vector2(0.5, 0.5):
		scale = Vector2(1.5, 1.5)
		y_limit -= 20
		position += Vector2(0, -20)


func _set_skin():
	var skin_data = ProfileBus.get_skin_data(ProfileBus.profile.chosen_skin)
	$LukaszczykWPandzie.sprite_frames = skin_data['spriteframe']
	$LukaszczykWPandzie.scale = Vector2(skin_data['scale'], skin_data['scale'])
	$LukaszczykWPandzie.offset = Vector2(0, skin_data['y_pos_offset'])
	$LukaszczykWPandzie.play()


func _reduce_motion(yes):
	if yes:
		$LukaszczykWPandzie.stop()
	else:
		$LukaszczykWPandzie.play("default")
