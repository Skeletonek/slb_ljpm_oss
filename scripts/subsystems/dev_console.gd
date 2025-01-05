extends CanvasLayer

signal error_msg_received(msg: String)
signal warning_msg_received(msg: String)
signal info_msg_received(msg: String)

const SUPPORTED_COMMANDS = [
	# Generic commands
	"help",
	"quit",
	"exit",
	"gamemap",
	"carride",
	"time",
	# Developer commands
	"enable_dev_buttons",
	"debug_info",
	"build_info",
	"sound_errors",
	"show_errors",
	"show_fps",
	# Achievement commands
	"achievement_award",
	"achievement_reset",
	# Music commands
	"music_play",
	"music_stop",
	"music_list",
	# Dialogic commands
	"timeline_start",
	"timeline_current",
	"timeline_list",
	"test_dialog",
	# Options commands
	"volume_master",
	"volume_sfx",
	"volume_voice",
	"volume_music",
	"volume_narrator",
	"fullscreen",
	"ui_scale",
	"ui_blur",
	"vsync",
	# Carride commands
	"cr_speedometer_value",
	"cr_playername",
	"cr_skin",
	"cr_map",
	# Cheats
	"god",
	"cr_ch_add_milk",
	"cr_ch_unlock_skins",
	"cr_ch_unlock_maps",
	]

const UPDATE_INTERVAL := 0.1
const ERROR_MSG_PREFIX_1 := "ERROR: "
const ERROR_MSG_PREFIX_2 := "USER ERROR: "
const ERROR_MSG_PREFIX_3 := "USER SCRIPT ERROR: "
const WARNING_MSG_PREFIX_1 := "WARNING: "
const WARNING_MSG_PREFIX_2 := "USER WARNING: "
const COMMAND_MSG_PREFIX := "DEV PROMPT: "
#Any logs with three spaces at the beginning will be ignored.
const IGNORE_PREFIX := "   "

var commands = {}
var command_history = []
var history_index = 0
var godot_log

@onready var log_rich_label = $PanelContainer/MarginContainer/VBoxContainer/LogRichLabel
@onready var prompt_edit = $PanelContainer/MarginContainer/VBoxContainer/PromptEdit
@onready var err_player = $ERRPlayer
@onready var wrn_player = $WRNPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_command_dict()
	godot_log = FileAccess.open("user://logs/godot.log", FileAccess.READ)
	SignalBus.dev_console.connect(_hide_dev_button)

	create_tween().set_loops(
	).tween_callback(_read_data
	).set_delay(UPDATE_INTERVAL)

	if OS.get_name() == "Android" && OS.is_debug_build():
		$AndroidLayer.show()


func _generate_command_dict():
	var commands_sorted = SUPPORTED_COMMANDS.duplicate()
	commands_sorted.sort()
	for x in commands_sorted:
		commands[x] = Callable(self, ("_"+x))


func _read_data():
	while godot_log.get_position() < godot_log.get_length():
		var new_line = godot_log.get_line()
		if new_line.begins_with(IGNORE_PREFIX):
			continue
		if new_line.begins_with(ERROR_MSG_PREFIX_1) or \
				new_line.begins_with(ERROR_MSG_PREFIX_2) or \
				new_line.begins_with(ERROR_MSG_PREFIX_3) \
		:
			log_rich_label.append_text("[color=red][ERR] " +
					new_line.trim_prefix(
						ERROR_MSG_PREFIX_1
					).trim_prefix(
						ERROR_MSG_PREFIX_2
					).trim_prefix(
						ERROR_MSG_PREFIX_3
					) + "[/color]")
			if SettingsBus.dev_error_sounds:
				err_player.play()
			if SettingsBus.dev_show_errors:
				DebugInfo.append_error(new_line)
		elif new_line.begins_with(WARNING_MSG_PREFIX_1) or \
				new_line.begins_with(WARNING_MSG_PREFIX_2) \
		:
			log_rich_label.append_text("[color=orange][WRN] " +
					new_line.trim_prefix(
						WARNING_MSG_PREFIX_1
					).trim_prefix(
						WARNING_MSG_PREFIX_2
					) + "[/color]")
			if SettingsBus.dev_error_sounds:
				wrn_player.play()
			if SettingsBus.dev_show_errors:
				DebugInfo.append_warning(new_line)
		elif new_line.begins_with(COMMAND_MSG_PREFIX):
			log_rich_label.append_text("[color=darkgray][CMD] " +
					new_line.trim_prefix(COMMAND_MSG_PREFIX) + "[/color]")
		else:
			log_rich_label.append_text("[LOG] " + new_line)
		log_rich_label.append_text("\n")


func _input(event):
	if SettingsBus.dev_console:
		if event.is_action("console_toggle"):
			prompt_edit.clear()
		if event.is_action_pressed("console_toggle"):
			visible = !visible
			if visible:
				prompt_edit.grab_focus()
		elif event.is_action_pressed("console_autocomplete"):
			_autocomplete()
		elif event.is_action_pressed("console_history_back"):
			_history(true)
		elif event.is_action_pressed("console_history_forward"):
			_history(false)


func _autocomplete():
	if visible:
		var index = commands.keys().find(prompt_edit.text)
		if index == -1:
			for x in commands.keys():
				if x.begins_with(prompt_edit.text):
					prompt_edit.text = x
					prompt_edit.caret_column = prompt_edit.text.length()
					break
		else:
			if index >= commands.size()-1:
				prompt_edit.text = commands.keys()[0]
			else:
				prompt_edit.text = commands.keys()[index+1]


func _history(backward: bool):
	if visible and not command_history.is_empty():
		prompt_edit.text = command_history[history_index-1]
		if backward:
			if history_index > 1:
				history_index -= 1
		else:
			if history_index < command_history.size():
				history_index += 1


func _on_show_button_pressed():
	visible = !visible
	if visible:
		prompt_edit.grab_focus()


func _hide_dev_button(yes: bool):
	if OS.get_name() == "Android":
		if yes:
			$AndroidLayer.show()
		else:
			$AndroidLayer.hide()


func _on_prompt_edit_text_submitted(new_text):
	print("DEV PROMPT: " + new_text)
	prompt_edit.grab_focus()
	prompt_edit.clear()
	command_history.push_back(new_text)
	history_index = command_history.size()

	var command_arr = Array(new_text.split(" "))
	if command_arr[0] not in commands:
		push_error("Unknown command")
		return
	var args = command_arr.duplicate()
	args.remove_at(0)
	var result = commands[command_arr[0]].callv(args)
	if result == false or result == null:
		push_error("Command failed")


# The 'setting' property is only for showing the value
# In GDScript it's imposssible to pass a primitive type as an reference
@warning_ignore("shadowed_global_identifier")
func _process_int(setting: int, value, min: int, max: int) -> Variant:
	if value.is_valid_int():
		var val = clampi(int(value), min, max)
		return val
	print("Value (int): " + str(setting))
	return null


@warning_ignore("shadowed_global_identifier")
func _process_float(setting: float, value, min: float, max: float) -> Variant:
	if value.is_valid_float():
		var val = clampf(float(value), min, max)
		return val
	print("Value (float): " + str(setting))
	return null


func _process_bool(setting: bool, value) -> Variant:
	if value == "0" or value == "false":
		return false
	if value == "1" or value == "true":
		return true
	print("Value (bool): " + str(setting))
	return null


func _process_string(setting: String, value) -> Variant:
	if value != "":
		return value
	print("Value (string): " + setting)
	return null


func _process_cheat() -> void:
	if not SettingsBus.cheats:
		push_warning("Saving data and obtaining achievements are now disabled until game restart!")
	SettingsBus.cheats = true


func _help() -> bool:
	var keys = commands.keys()
	print(str(keys).replace(", ","\n").trim_prefix("[").trim_suffix("]"))
	return true


func _quit() -> bool:
	get_tree().quit()
	return true


func _exit() -> bool:
	return _quit()


func _gamemap() -> bool:
	get_tree().change_scene_to_file("res://scenes/testScene.tscn")
	return true


func _carride() -> bool:
	if SettingsBus.playername.split("#")[0] == "":
		push_error("Your name is not set! " +
			"Set your playername in gameplay page of game settings or via cr_playername command! ")
		return true
	get_tree().change_scene_to_file("res://scenes/carride.tscn")
	return true


func _time() -> bool:
	print(Time.get_datetime_string_from_system())
	return true


func _enable_dev_buttons() -> bool:
	if OS.is_debug_build():
		var node = get_node("/root/mainMenu")
		node.emit_signal("signal_debug_dev_buttons")
	else:
		push_error("This command is supported only in Debug build")
	return true


func _debug_info() -> bool:
	print(DebugInfo.debug_info())
	return true


func _build_info() -> bool:
	DebugInfo.toggle()
	return true


func _sound_errors(arg = "") -> bool:
	var ret = _process_bool(SettingsBus.dev_error_sounds, arg)
	if ret != null:
		SettingsBus.dev_error_sounds = ret
	return true


func _show_errors(arg = "") -> bool:
	var ret = _process_bool(SettingsBus.dev_show_errors, arg)
	if ret != null:
		SettingsBus.dev_show_errors = ret
	DebugInfo.toggle_errors()
	return true


func _show_fps(arg = "") -> bool:
	var ret = _process_bool(SettingsBus.dev_show_fps, arg)
	if ret != null:
		SettingsBus.dev_show_fps = ret
	DebugInfo.toggle_fps()
	return true


# DO NOT SET DEFAULT VALUE FOR ARG
func _achievement_award(arg) -> bool:
	if OS.is_debug_build():
		if arg.to_lower() == "all":
			print("Awarding all achievements!!! \\o/")
			AchievementSystem.debug_award_achv_all()
		else:
			print("Awarding \"" + arg + "\"")
			var status = AchievementSystem.call_achievement(arg)
			if status != true:
				push_error("Awarding failed!")
	else:
		push_error("This comman	d is supported only in Debug build")
	return true


func _achievement_reset(arg = "") -> bool:
	if arg != "":
		AchievementSystem.debug_reset_test_achv(arg)
		print(arg + " achievement has been reset")
	else:
		AchievementSystem.debug_reset_test_achv_all()
		print("All achievements have been reset")
	return true


func _music_play(arg = null) -> bool:
	if arg == null:
		_music_list()
	else:
		if not arg.ends_with(".ogg"):
			arg += ".ogg"
		print("Playing " + arg)
		GlobalMusic.stream = load("res://audio/music/" + arg)
		GlobalMusic.play()
	return true


func _music_stop() -> bool:
	GlobalMusic.stop()
	return true


func _music_list() -> bool:
	var dir = DirAccess.open("res://audio/music")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".import"):
				print(file_name.trim_suffix(".import"))
			file_name = dir.get_next()
		return true
	return false



func _timeline_start(arg = null) -> bool:
	if arg == null:
		_timeline_list()
	else:
		if not arg.ends_with(".dtl"):
			arg += ".dtl"
		print("Starting " + arg)
		get_tree().change_scene_to_file("res://scenes/a1_br.tscn")
		SignalBus.dialogic_path = "res://dialogic/timelines/" + arg
	return true


func _timeline_current() -> bool:
	print("Current timeline: " + str(null))
	return true


func _timeline_list() -> bool:
	var dir = DirAccess.open("res://dialogic/timelines")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				print(file_name)
			file_name = dir.get_next()
		return true
	return false


func _test_dialog() -> bool:
	print("Starting test dialog")
	get_tree().change_scene_to_file("res://scenes/a1_br.tscn")
	SignalBus.dialogic_path = "res://dialogic/timelines/test.dtl"
	return true


func _volume_master(arg = "") -> bool:
	var ret = _process_float(SettingsBus.volume[SettingsBus.AudioBus.MASTER], arg, 0.0, 1.0)
	if ret != null:
		SettingsBus.set_audio_volume(SettingsBus.AudioBus.MASTER, ret)
	return true


func _volume_sfx(arg = "") -> bool:
	var ret = _process_float(SettingsBus.volume[SettingsBus.AudioBus.SFX], arg, 0.0, 1.0)
	if ret != null:
		SettingsBus.set_audio_volume(SettingsBus.AudioBus.SFX, ret)
	return true


func _volume_voice(arg = "") -> bool:
	var ret = _process_float(SettingsBus.volume[SettingsBus.AudioBus.VOICE], arg, 0.0, 1.0)
	if ret != null:
		SettingsBus.set_audio_volume(SettingsBus.AudioBus.VOICE, ret)
	return true


func _volume_music(arg = "") -> bool:
	var ret = _process_float(SettingsBus.volume[SettingsBus.AudioBus.MUSIC], arg, 0.0, 1.0)
	if ret != null:
		SettingsBus.set_audio_volume(SettingsBus.AudioBus.MUSIC, ret)
	return true


func _volume_narrator(arg = "") -> bool:
	var ret = _process_float(SettingsBus.volume[SettingsBus.AudioBus.NARRATOR], arg, 0.0, 1.0)
	if ret != null:
		SettingsBus.set_audio_volume(SettingsBus.AudioBus.NARRATOR, ret)
	return true


func _fullscreen() -> bool:
	var current_fullscreen = SettingsBus.fullscreen
	SettingsBus.fullscreen=!current_fullscreen
	var window_mode = (
		DisplayServer.WINDOW_MODE_FULLSCREEN if !current_fullscreen
		else DisplayServer.WINDOW_MODE_WINDOWED
		)
	SettingsBus.cfg_window_mode = window_mode
	SettingsBus.save_override()
	DisplayServer.window_set_mode(window_mode)
	return true


func _ui_scale(arg="") -> bool:
	var ret = _process_float(SettingsBus.ui_scaling, arg, 0.7, 1.3)
	if ret != null:
		SettingsBus.ui_scaling = ret
		get_tree().root.content_scale_factor = ret
	return true


func _ui_blur(arg="") -> bool:
	var ret = _process_bool(SettingsBus.ui_blur, arg)
	if ret != null:
		SettingsBus.set_ui_shader(ret)
	return true


func _vsync(arg="") -> bool:
	var ret = _process_int(
		SettingsBus.vsync,
		arg,
		0,
		3,
	)
	if ret != null:
		SettingsBus.vsync = ret
		DisplayServer.window_set_vsync_mode(ret)
	return true


func _cr_speedometer_value(arg="") -> bool:
	var ret = _process_bool(SettingsBus.cr_speedometer_label, arg)
	if ret != null:
		SettingsBus.cr_speedometer_label = ret
		SignalBus.emit_signal("cr_speedometer_value", ret)
	return true


func _cr_playername(arg="") -> bool:
	var ret = _process_string(SettingsBus.playername.split("#")[0], arg)
	if ret != null:
		SettingsBus.playername = arg.replace("\n", "") + SettingsBus.playername.right(9)
	return true


func _cr_skin(arg="") -> bool:
	var ret = _process_int(
		ProfileBus.profile.chosen_skin,
		arg,
		0,
		Profile.Skins.size()-1
	)
	if ret != null:
		if ProfileBus.profile.change_skin(ret as Profile.Skins):
			SignalBus.cr_skin.emit()
		else:
			push_error("You don't own this skin!")
	return true


func _cr_map(arg="") -> bool:
	var ret = _process_int(
		ProfileBus.profile.chosen_map,
		arg,
		0,
		Profile.Maps.size()-1
	)
	if ret != null:
		if ProfileBus.profile.change_map(ret as Profile.Maps):
			SignalBus.cr_map.emit()
		else:
			push_error("You don't own this skin!")
	return true


func _god() -> bool:
	_process_cheat()
	SettingsBus.godmode = !SettingsBus.godmode
	print("Godmode " + ("enabled" if SettingsBus.godmode else "disabled"))
	return true


func _cr_ch_add_milk(arg="") -> bool:
	_process_cheat()
	if arg.is_valid_int():
		ProfileBus.profile.milks += int(arg)
		SignalBus.cr_update_milks_count.emit()
	return true


func _cr_ch_unlock_skins() -> bool:
	_process_cheat()
	for x in ProfileBus.profile.skins.size():
		ProfileBus.profile.skins[x] = true
		SignalBus.cr_ch_unlock_skins.emit()
		SignalBus.ch_unlock_skins = true
	return true


func _cr_ch_unlock_maps() -> bool:
	_process_cheat()
	for x in ProfileBus.profile.maps.size():
		ProfileBus.profile.maps[x] = true
		SignalBus.cr_ch_unlock_maps.emit()
		SignalBus.ch_unlock_maps = true
	return true
