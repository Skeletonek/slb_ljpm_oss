extends Control


@onready var options_layer = $OptionsLayer
@onready var http_request = $HTTPRequest
@onready var update_button = $MainMenuLayer/UpdateButton

@export var skeletonek_logo: Control
@export var godot_logo: Control

var build_number: int = ProjectSettings.get_setting("application/config/build_number")
var new_build_code: String
var download_url: String
var changelog_url: String

func _ready():
	skeletonek_logo.gui_input.connect(_on_skeletonek_logo_click)
	godot_logo.gui_input.connect(_on_godot_logo_click)
	
#	GlobalMusic.finished.connect(_on_global_music_finished)
#	if not GlobalMusic.is_playing():
#		_on_global_music_finished()
	$MainMenuLayer/VBoxContainer/ContinueButton.grab_focus()
	
	print(Input.get_connected_joypads())
	
	print(_debug_info())
	var device_info_label = $CreditsLayer/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/DeviceInfo
	device_info_label.text = _debug_info() + "\n\n"
	var game_info_label = $CreditsLayer/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/GameInfo
	game_info_label.text = "Wersja gry: " + ProjectSettings.get_setting("application/config/version") + "\n\n"
	
	# Check for update
	http_request.request_completed.connect(_validate_update)
	_check_update()


func _on_global_music_finished():
	var date = int(Time.get_unix_time_from_system()) % 2
	print("Unix Timestamp % 2 = ", date)
	if date == 0:
		GlobalMusic.stream = load("res://music/tech-junkie.ogg")
	else:
		GlobalMusic.stream = load("res://music/tech-junkie.ogg")
	GlobalMusic.play()


func _debug_info() -> String:
	var GPUAPI: String
	if RenderingServer.get_rendering_device() == null:
		GPUAPI = "OpenGL"
	else:
		GPUAPI = "Vulkan"
	var text = "Godot Engine " + Engine.get_version_info().string + "\n" + \
	"OS: " + OS.get_name() + " " + OS.get_distribution_name() + " " + OS.get_version() + "\n" + \
	"CPU: " + OS.get_processor_name() + " " + str(OS.get_processor_count()) + " threads \n" + \
	"GPU: " + RenderingServer.get_video_adapter_vendor() + " " + RenderingServer.get_video_adapter_name() + "\n" + \
	"GPU API: " + GPUAPI + " " + RenderingServer.get_video_adapter_api_version()
	return text


func _check_update():
	http_request.request("https://server.skeletonek.com/app/ljpm/update.json")
	print("Checking if update is available...")


func _validate_update(result, response_code, headers, body):
	if result != 0:
		push_warning("Couldn't check for update! Do we have an internet?")
		update_button.text = "Brak połączenia"
		update_button.disabled = true
		update_button.show()
		get_tree().create_timer(10).timeout.connect(_check_update)
		pass # There is a connection error
	else:
		print("Correctly checked if update is available")
		var json = JSON.parse_string(body.get_string_from_utf8())
		if int(json["buildNumber"]) > build_number:
			print("Update found!")
			download_url = json["downloadURL"]
			changelog_url = json["changelogURL"]
			new_build_code = json["buildCode"]
			update_button.text = "Dostępna aktualizacja!"
			update_button.disabled = false
			update_button.show()


func _update_game():
	OS.shell_open(download_url)
	SettingsBus.save_config()
	get_tree().quit()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SettingsBus.save_config()
		get_tree().quit() # default behavior


func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://scenes/carride.tscn")


func _on_options_button_pressed():
	_hide_all_layers()
	$OptionsLayer.show()
	$OptionsLayer.back_button.grab_focus()


func _on_credits_button_pressed():
	_hide_all_layers()
	$CreditsLayer.show()
	$CreditsLayer/PanelContainer/MarginContainer/VBoxContainer/BackButton.grab_focus()


func _on_hi_score_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Leaderboard.tscn")


func _on_exit_button_pressed():
	SettingsBus.save_config()
	get_tree().quit()


func _on_back_button_pressed():
	_hide_all_layers()
	$MainMenuLayer.show()
	$MainMenuLayer/VBoxContainer/ContinueButton.grab_focus()


func _hide_all_layers():
	$MainMenuLayer.hide()
	$OptionsLayer.hide()
	$CreditsLayer.hide()


func _on_skeletonek_logo_click(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			OS.shell_open("https://www.skeletonek.com")


func _on_godot_logo_click(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			OS.shell_open("https://godotengine.org")


func _on_easter_egg_button_pressed():
	OS.shell_open("https://youtu.be/dQw4w9WgXcQ?si=FRObNjwf145_svmv")

