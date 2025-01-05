extends Camera2D

@export var animation_speed: int = 800

@export var speed := 200
var stop_processing := false

@onready var panda_node: AnimatedSprite2D = $LukaszczykWPandzie
@onready var button: TouchScreenButton = $LukaszczykWPandzie/TouchScreenButton


func _ready():
	panda_node.play("default")
	var anim_player = panda_node.get_child(0) as AnimationPlayer
	anim_player.play("main_menu_sway")


func _process(_delta):
	var z = 1 / get_tree().root.get_content_scale_factor()
	zoom = Vector2(z, z)
