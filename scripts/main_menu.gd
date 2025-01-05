extends Control

signal signal_debug_dev_buttons

@export var skeletonek_logo: Control
@export var godot_logo: Control
@export var focus_node: Control

var build_number: int = ProjectSettings.get_setting("application/config/build_number")
var version: String
var download_url: String
var changelog: String

@onready var options_layer = $OptionsLayer
@onready var http_request = $HTTPRequest
@onready var http_request_changelog = $HTTPRequest2
@onready var update_button = $MainMenuLayer/UpdateButton


func _ready():
	if GlobalMusic.stream.resource_path == "res://audio/music/the-great-rescue.ogg":
		var music_tick = GlobalMusic.get_playback_position()
		GlobalMusic.stream = load("res://audio/music/the-greatest-rescue.ogg")
		GlobalMusic.play()
		GlobalMusic.seek(music_tick)

	skeletonek_logo.gui_input.connect(_on_skeletonek_logo_click)
	godot_logo.gui_input.connect(_on_godot_logo_click)

#	GlobalMusic.finished.connect(_on_global_music_finished)
#	if not GlobalMusic.is_playing():
#		_on_global_music_finished()
	focus_node.grab_focus()

	# signal_debug_dev_buttons.connect(_enable_dev_buttons)
	# Developer console is inaccessible on Android, unless you have plugged in a keyboard
	# if OS.get_name() == "Android" and OS.is_debug_build():
		# $MainMenuLayer/DevButtons.visible = true

	var device_info_label = $CreditsLayer/PanelContainer/MarginContainer/\
		VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/DeviceInfo
	device_info_label.text = DebugInfo.debug_info() + "\n\n"
	var game_info_label = $CreditsLayer/PanelContainer/MarginContainer/\
		VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/GameInfo
	game_info_label.text = "Wersja gry: " + \
		ProjectSettings.get_setting("application/config/version") + "\n\n"

	# Check for update
	http_request.request_completed.connect(_validate_update)
	http_request_changelog.request_completed.connect(_download_changelog)
	_check_update()

	if not get_parent() is Window:
		get_parent().animation.button.pressed.connect(_on_easter_egg_button_pressed)
	else:
		$MenuAnim.button.pressed.connect(_on_easter_egg_button_pressed)


func _on_global_music_finished():
	var date = int(Time.get_unix_time_from_system()) % 2
	print("Unix Timestamp % 2 = ", date)
	match(date):
		0:
			# gdlint:ignore=duplicated-load
			GlobalMusic.stream = load("res://audio/music/the-greatest-rescue.ogg")
		1:
			GlobalMusic.stream = load("res://audio/music/tech-junkie.ogg")
	GlobalMusic.play()


func _enable_dev_buttons():
	pass
	# $MainMenuLayer/DevButtons.visible = true


func _check_update():
	http_request.request("https://server.skeletonek.com/app/ljpm/update.json")
	print("Checking if update is available...")


func _validate_update(result, _response_code, _headers, body):
	if result != 0:
		push_warning("Couldn't check for update! Do we have an internet?")
		update_button.text = "Brak połączenia"
		update_button.disabled = true
		update_button.show()
		get_tree().create_timer(10).timeout.connect(_check_update)
	else:
		print("Correctly checked if update is available")
		var json = JSON.parse_string(body.get_string_from_utf8())
		if int(json["buildNumber"]) > build_number:
			print("Update found!")
			download_url = json["downloadURL"]
			version = json["buildCode"]

			var changelog_url = json["changelogURL"]
			push_warning(changelog_url)
			http_request_changelog.request(changelog_url)

			$PopupChangelog.update_version_data(version, download_url)
			update_button.text = "Dostępna aktualizacja!"
			update_button.disabled = false
			update_button.show()


func _download_changelog(_result, _response_code, _headers, body):
	$PopupChangelog.update_changelog_data(body.get_string_from_utf8())


func _update_game():
	$PopupChangelog.show()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST || \
			what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SettingsBus.save_config()
		ProfileBus.save_profile_to_file()
		get_tree().quit() # default behavior


func _on_continue_button_pressed():
	if SettingsBus.playername.split("#")[0] == "":
		$popup_input.show()
		$popup_input.save_button.connect(_on_continue_button_pressed)
		return
	get_tree().change_scene_to_file("res://scenes/carride.tscn")


func _on_options_button_pressed():
	_hide_all_layers()
	$OptionsLayer.show()
	$OptionsLayer.back_button.grab_focus()


func _on_credits_button_pressed():
	_hide_all_layers()
	$CreditsLayer.show()
	$CreditsLayer/PanelContainer/MarginContainer/VBoxContainer/BackButton.grab_focus()


func _on_achievements_button_pressed():
	_hide_all_layers()
	$AchievementsLayer.show()
	$AchievementsLayer/PanelContainer/VBoxContainer/MarginContainer2/BackButton.grab_focus()


func _on_statistics_button_pressed():
	_hide_all_layers()
	$ProfileLayer.show()
	$ProfileLayer/PanelContainer/VBoxContainer/MarginContainer2/BackButton.grab_focus()


func _on_hi_score_button_pressed():
	$LeaderboardLayer.boot()
	_hide_all_layers()
	$LeaderboardLayer.show()
	$LeaderboardLayer/Board/CloseButtonContainer/CloseButton.grab_focus()


func _on_exit_button_pressed():
	SettingsBus.save_config()
	ProfileBus.save_profile_to_file()
	get_tree().quit()


func _on_back_button_pressed():
	_hide_all_layers()
	$MainMenuLayer.show()
	focus_node.grab_focus()


func _hide_all_layers():
	$MainMenuLayer.hide()
	$OptionsLayer.hide()
	$LeaderboardLayer.hide()
	$AchievementsLayer.hide()
	$CreditsLayer.hide()
	$ProfileLayer.hide()


func _on_skeletonek_logo_click(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			OS.shell_open("https://www.skeletonek.com")


func _on_godot_logo_click(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			OS.shell_open("https://godotengine.org")


func _on_easter_egg_button_pressed():
	if $MainMenuLayer.visible && not $popup_input.visible && not $PopupChangelog.visible:
		AchievementSystem.call_achievement("rick_roll")
		OS.shell_open("https://youtu.be/dQw4w9WgXcQ")
