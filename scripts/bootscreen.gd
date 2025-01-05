extends Control


const MAINMENU_SCENE: String = "res://scenes/mainMenu.tscn"

var block = false
@onready var menu = get_parent().get_node("mainMenu")

# Called when the node enters the scene tree for the first time.
func _ready():
	menu.get_child(1).queue_free()
	menu.modulate_anim()
	$AnimationPlayer.animation_finished.connect(_exit_animation)


func _exit_animation(_anim_name = ""):
	queue_free()


func _input(event):
	if not block and Engine.get_frames_drawn() > 1 and \
			((event is InputEventKey) or
			(event is InputEventScreenTouch) or
			(event is InputEventMouseButton)):
		block = true
		menu.stop_modulate_anim()
		_exit_animation()
