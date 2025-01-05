extends CanvasLayer


@onready var resume_button = $CenterContainer/PanelContainer/MarginContainer/\
	VBoxContainer/ResumeButton


func _ready():
	if OS.get_name() == "Android":
		$AndroidPauseLayer.show()
	GlobalMusic.connect_buttons(self)


func _process(_delta):
	pass


func _input(event):
	if event.is_action_pressed("return"):
		_switch_visibility()


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_switch_visibility()


func _on_pause_button_pressed():
	_switch_visibility()


func _switch_visibility():
	if get_tree().paused:
		_hide_all_layers()
		get_tree().paused = false
		GlobalMusic.button_sound(false, GlobalMusic.BtnType.SWITCH)
	elif not get_tree().paused:
		show()
		get_tree().paused = true
		resume_button.grab_focus()
		GlobalMusic.button_sound(true, GlobalMusic.BtnType.SWITCH)


func _on_resume_button_pressed():
	hide()
	get_tree().paused = false


func _on_achievements_button_pressed():
	_hide_all_layers()
	$AchievementsLayer.show()
	$AchievementsLayer/PanelContainer/VBoxContainer/MarginContainer2/BackButton.grab_focus()


func _on_settings_button_pressed():
	_hide_all_layers()
	$OptionsLayer.show()
	$OptionsLayer.back_button.grab_focus()


func _on_main_menu_button_pressed():
	_hide_all_layers()
	get_tree().paused = false
	# HACK Workaround for Godot bug #48607
	get_tree().call_deferred("change_scene_to_file", "res://scenes/mainMenu.tscn")


func _on_exit_button_pressed():
	get_tree().paused = false
	SettingsBus.save_config()
	get_tree().quit()


func _on_back_button_pressed():
	_hide_all_layers()
	show()
	resume_button.grab_focus()


func _hide_all_layers():
	hide()
	$AchievementsLayer.hide()
	$OptionsLayer.hide()
