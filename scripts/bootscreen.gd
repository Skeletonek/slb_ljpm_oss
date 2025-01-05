extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.animation_finished.connect(_load_main_menu)


func _load_main_menu(_anim_name = ""):
	if not SettingsBus.skip_intro:
		get_tree().change_scene_to_file("res://scenes/intro.tscn")
		return
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")


func _input(event):
	if (event is InputEventKey) or (event is InputEventScreenTouch) or (event is InputEventMouseButton):
		_load_main_menu()
