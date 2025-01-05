extends Camera2D

@onready var road_node: Sprite2D = $Road
@onready var panda_node: AnimatedSprite2D = $LukaszczykWPandzie
@export var animation_speed: int = 800


func _ready():
	if SettingsBus.reduced_motion:
		road_node.texture = load("res://sprites/RoadRM.png")
	SignalBus.reduce_motion.connect(_reduce_motion)
	panda_node.play("default")
	var anim_player = panda_node.get_child(0) as AnimationPlayer
	anim_player.play("main_menu_sway")


func _process(delta):
	var z = 1 / get_tree().root.get_content_scale_factor()
	zoom = Vector2(z, z)
	road_node.position += Vector2(-animation_speed,0) * delta
	if road_node.position.x <= -45:
		road_node.position.x = 35 + (road_node.position.x + 45)


func _reduce_motion(yes):
		road_node.texture = ( load("res://sprites/RoadRM.png") if yes 
			else load("res://sprites/Road.png")
		)
