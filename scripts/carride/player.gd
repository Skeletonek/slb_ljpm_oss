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

var explosion_tween: Tween
var death_timer: Timer

func _ready() -> void:
	SignalBus.reduce_motion.connect(_reduce_motion)
	SignalBus.cr_skin.connect(_set_skin)
	_set_skin()
	if SettingsBus.reduced_motion:
		$LukaszczykWPandzie.stop()
	if owner.version_2:
		original_y_position = position.y
		death_timer = $DeathTimer


func _process(delta) -> void:
	position += move_vector * delta * owner.time_scale
	if move_vector.y > 0:
		if position.y >= y_limit:
			move_vector = Vector2(0,0)
	elif move_vector.y < 0:
		if position.y <= y_limit:
			move_vector = Vector2(0,0)


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
	var ar = area.get_parent()
	if ar.is_in_group("Milk"):
		_area_entered_milk(ar)
	if ar.is_in_group("Powerups"):
		_area_entered_powerup(ar)
	if ar.is_in_group("Obstacles"):
		_area_entered_obstacle(ar)


func _area_entered_milk(ar):
	if process_mode != Node.PROCESS_MODE_DISABLED:
		if ar.is_in_group("MilkTriple"):
			owner.milks += 3
		else:
			owner.milks += 1
		_milk_achievement_check()


func _area_entered_powerup(ar):
	owner.powerup = ar


func _area_entered_obstacle(ar):
	if not dont_collide or ar.is_in_group("OutOfBounds"):
		$CrashPlayer.play()
		if ar.is_in_group("OutOfBounds"):
			AchievementSystem.call_achievement("offroad")
		if not SettingsBus.godmode:
			owner.lives -= 1
			if owner.version_2:
				owner.gui.hide_one_live()
				owner.powerup = null
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

			call_deferred("set", "process_mode", Node.PROCESS_MODE_DISABLED)
			if owner.lives <= 0:
				owner.game_over()
			else:
				death_timer.start(2)
				await death_timer.timeout
				position = Vector2(position.x, original_y_position)
				y_limit = position.y
				call_deferred("set", "process_mode", Node.PROCESS_MODE_INHERIT)
				owner.speed = owner.original_speed
				$LukaszczykWPandzie.show()

				dont_collide = true
				death_timer.start(1)
				await death_timer.timeout
				dont_collide = false


func move(dir_up: bool):
	move_vector = Vector2(0, (-vertical_speed if dir_up else vertical_speed))
	y_limit += -lane_y_diff if dir_up else lane_y_diff


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


func _milk_achievement_check():
	var stats_milk = ProfileBus.profile.milks_total
	if stats_milk + owner.milks >= 1000:
		AchievementSystem.call_achievement("milk_1000")
	if stats_milk + owner.milks >= 500:
		AchievementSystem.call_achievement("milk_500")
	if stats_milk + owner.milks >= 100:
		AchievementSystem.call_achievement("milk_100")
