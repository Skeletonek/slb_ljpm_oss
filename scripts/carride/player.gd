extends Area2D

@export var vertical_speed = 500
@export var explosion_anim_duration_multiplier = 1
@export var lane_y_diff = 80

var move_vector: Vector2
var y_limit := position.y
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.reduce_motion.connect(_reduce_motion)
	_set_skin()
	if SettingsBus.reduced_motion:
		$LukaszczykWPandzie.stop()
	SignalBus.cr_skin.connect(_set_skin)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += move_vector * delta
	if move_vector.y > 0:
		if position.y >= y_limit:
			move_vector = Vector2(0,0)
	elif move_vector.y < 0:
		if position.y <= y_limit:
			move_vector = Vector2(0,0)


func _input(event):
	if event.is_action_pressed("move_up"):
		if event is InputEventJoypadMotion:
			if event.get_action_strength("move_up") != SettingsBus.gamepad_deadzone:
				return
		move(true)
	elif event.is_action_pressed("move_down"):
		if event is InputEventJoypadMotion:
			if event.get_action_strength("move_down") != SettingsBus.gamepad_deadzone:
				return
		move(false)
#	elif event is InputEventScreenTouch:
#		if event.pressed and event.index == 0:
#			if event.position.y > (get_viewport().get_visible_rect().size.y / 2):
#				move(false)
#			else:
#				move(true)


func _on_area_entered(area):
	if area.is_in_group("Milk"):
		if process_mode != Node.PROCESS_MODE_DISABLED:
			area.queue_free()
			if area.is_in_group("MilkTriple"):
				owner.milks += 3
			else:
				owner.milks += 1
			$MilkPlayer.play()
			_milk_achievement_check()
	elif area.is_in_group("Obstacles"):
		$CrashPlayer.play()
		if not SettingsBus.godmode:
			$LukaszczykWPandzie.hide()
			$Explosion.play()
			var tween = get_tree().create_tween()
			tween.tween_property(
					$Explosion,
					"position",
					Vector2.LEFT * owner.speed,
					explosion_anim_duration_multiplier
			)
			tween.tween_callback($Explosion.queue_free)
			owner.game_over()
			call_deferred("set", "process_mode", Node.PROCESS_MODE_DISABLED)
		if area.name.contains("OutOfBounds"):
			AchievementSystem.call_achievement("offroad")


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

