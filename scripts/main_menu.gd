extends Control

signal signal_debug_dev_buttons

@export var focus_node: Control

var animated_logo = preload("res://images/animated_logo/mainMenu.tres")
var build_number: int = ProjectSettings.get_setting("application/config/build_number")
var version: String
var download_url: String
var changelog: String
var easter_egg_clickable := false

@onready var options_layer = $OptionsLayer

@onready var update_button = $MainMenuLayer/UpdateButton
@onready var rick_player: VideoStreamPlayer = $Rick

@onready var http_request = $HTTPRequest
@onready var http_request_changelog = $HTTPRequest2
@onready var player_name_input_popup = $PopupInput


func modulate_anim():
	$AnimationPlayer.play("BootAnim")


func stop_modulate_anim():
	$AnimationPlayer.seek($AnimationPlayer.current_animation_length)


func _ready() -> void:
	$MainMenuLayer/VBoxContainer2/AnimatedSprite2D.sprite_frames = animated_logo
	# This is for the SLB2: TGRa, not LJPM
	# if GlobalMusic.stream.resource_path == "res://audio/music/the-great-rescue.ogg":
	# 	var music_tick = GlobalMusic.get_playback_position()
	# 	GlobalMusic.stream = load("res://audio/music/the-greatest-rescue.ogg")
	# 	GlobalMusic.play()
	# 	GlobalMusic.seek(music_tick)

	focus_node.grab_focus()

	GlobalMusic.connect_buttons(self)
	# if SettingsBus.first_boot:
		# $PopupTelemetry.show()

	# Check for update
	http_request.request_completed.connect(_validate_update)
	http_request_changelog.request_completed.connect(_download_changelog)
	_check_update()

	if not get_parent() is Window:
		get_parent().animation.luk_button.pressed.connect(_on_easter_egg_button_pressed)
	else:
		$MenuAnim.luk_button.pressed.connect(_on_easter_egg_button_pressed)


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
		update_button.hide()
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
	if ProfileBus.profile.playername == "":
		player_name_input_popup.show()
		player_name_input_popup.save_button.connect(_on_continue_button_pressed)
		return
	# HACK Workaround for Godot bug #48607
	get_tree().call_deferred("change_scene_to_file", "res://scenes/carride.tscn")


func _on_new_game_2_0_button_pressed():
	if ProfileBus.profile.playername == "":
		player_name_input_popup.show()
		player_name_input_popup.save_button.connect(_on_new_game_2_0_button_pressed)
		return
	# HACK Workaround for Godot bug #48607
	get_tree().call_deferred("change_scene_to_file", "res://scenes/carride2_0.tscn")


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


func _on_skin_shop_button_pressed():
	_hide_all_layers()
	$ShopLayer.show()
	$ShopLayer/PanelContainer/VBoxContainer/MarginContainer/BackButton.grab_focus()


func _on_statistics_button_pressed():
	_hide_all_layers()
	$ProfileLayer.show()
	$ProfileLayer/PanelContainer/VBoxContainer/MarginContainer2/BackButton.grab_focus()


func _on_hi_score_button_pressed():
	$LeaderboardLayer.boot()
	_hide_all_layers()
	$LeaderboardLayer.show()
	$LeaderboardLayer/Board/CloseButtonContainer/CloseButton.grab_focus()


func _on_hi_score_2_button_pressed():
	$Leaderboard2MilkLayer.boot()
	_hide_all_layers()
	$Leaderboard2MilkLayer.show()
	$Leaderboard2MilkLayer/Board/CloseButtonContainer/CloseButton.grab_focus()

func _on_hi_score_2_distance_button_pressed():
	$Leaderboard2DistanceLayer.boot()
	_hide_all_layers()
	$Leaderboard2DistanceLayer.show()
	$Leaderboard2DistanceLayer/Board/CloseButtonContainer/CloseButton.grab_focus()


func _on_exit_button_pressed():
	SettingsBus.save_config()
	ProfileBus.save_profile_to_file()
	get_tree().quit()


func _on_back_button_pressed():
	_hide_all_layers()
	$MainMenuLayer.show()
	focus_node.grab_focus()
	easter_egg_clickable = true


func _hide_all_layers():
	$MainMenuLayer.hide()
	$OptionsLayer.hide()
	$LeaderboardLayer.hide()
	$Leaderboard2MilkLayer.hide()
	$Leaderboard2DistanceLayer.hide()
	$AchievementsLayer.hide()
	$CreditsLayer.hide()
	$ProfileLayer.hide()
	$ShopLayer.hide()
	$MainMenuLayer/VBoxContainer/Profile/ProfileToggleButton.set_pressed_no_signal(false)
	$MainMenuLayer/VBoxContainer/Profile/ProfileToggled.hide()
	$MainMenuLayer/VBoxContainer/Scoreboard/ScoreboardToggleButton.set_pressed_no_signal(false)
	$MainMenuLayer/VBoxContainer/Scoreboard/ScoreboardToggled.hide()
	$MainMenuLayer/VBoxContainer/Game/GameToggleButton.set_pressed_no_signal(false)
	$MainMenuLayer/VBoxContainer/Game/GameToggled.hide()
	easter_egg_clickable = false


func switch_easter_egg_clickable(no: bool) -> void:
	easter_egg_clickable = !no


func _on_easter_egg_button_pressed():
	if easter_egg_clickable && not player_name_input_popup.visible && not $PopupChangelog.visible:
		AchievementSystem.call_achievement("rick_roll")
		GlobalMusic.stop()
		rick_player.play()
		# OS.shell_open("https://youtu.be/dQw4w9WgXcQ")


func _on_rick_finished():
	AchievementSystem.call_achievement("rick_rolled")
	rick_player.play()
