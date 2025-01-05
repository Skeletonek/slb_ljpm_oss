extends Area2D

@export var speed = 500

var move_vector: Vector2
var y_limit = 60
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.reduce_motion.connect(_reduce_motion)
	if SettingsBus.reduced_motion:
		$LukaszczykWPandzie.stop()


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
		move(true)
	elif event.is_action_pressed("move_down"):
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
			owner.milks += 1
			$MilkPlayer.play()
	elif area.is_in_group("Obstacles"):
		$CrashPlayer.play()
		if not SettingsBus.godmode:
			hide()
			process_mode = Node.PROCESS_MODE_DISABLED
			$MilkPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
			owner.game_over()


func move(dir_up: bool):
	move_vector = Vector2(0, (-speed if dir_up else speed))
	y_limit += -80 if dir_up else 80


func _reduce_motion(yes):
	if yes: 
		$LukaszczykWPandzie.stop()
	else:
		$LukaszczykWPandzie.play("default")
