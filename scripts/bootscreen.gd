extends Control


const MAINMENU_SCENE: String = "res://scenes/mainMenu.tscn"

var block = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.animation_finished.connect(_load_main_menu)
	ResourceLoader.load_threaded_request(MAINMENU_SCENE)

func _load_main_menu(_anim_name = ""):
	# if not SettingsBus.skip_intro:
	# 	get_tree().change_scene_to_file("res://scenes/intro.tscn")
	# 	return
	# get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
	var menu_scene = ResourceLoader.load_threaded_get(MAINMENU_SCENE)
	var menu = menu_scene.instantiate()
	menu.get_child(0).queue_free()
	get_parent().add_child(menu)
	queue_free()


func _input(event):
	if not block and ((event is InputEventKey) or (event is InputEventScreenTouch) or (event is InputEventMouseButton)):
		block = true
		_load_main_menu()
