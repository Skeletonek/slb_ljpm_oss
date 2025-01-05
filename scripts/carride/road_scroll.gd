extends Sprite2D

const SPEED_INCREMENT := 300
@export var jump_point := -1440
@export var parallax_multiplier := 1.0
@export var root_node: Node2D


func _ready():
	SignalBus.reduce_motion.connect(_reduce_motion)
	if SettingsBus.reduced_motion:
		_reduce_motion(true)


func _process(delta):
	if root_node.stop_processing:
		if root_node.speed <= -300:
			return
	position += Vector2(
			min(0,-(root_node.speed + SPEED_INCREMENT)),
			0
	) * delta * parallax_multiplier
	if position.x <= jump_point:
		position.x = position.x + -jump_point


func _reduce_motion(yes):
	if name == "Road":
		texture = ( load("res://sprites/RoadRM.png") if yes
				else load("res://sprites/Road.png")
		)
