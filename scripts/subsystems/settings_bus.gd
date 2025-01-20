extends Node

enum TouchscreenControlMode {
	TAP,
	SWIPE,
	VBUTTONS
}

enum AudioBus {
	MASTER,
	SFX,
	VOICE,
	MUSIC,
	NARRATOR
}

const DESKTOP_PLATFORM = ["Windows", "UWP", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD"]
const API_KEY = ""

var os_id = 1 if OS.get_name() == "Windows" else 0
var first_boot := false

var ui_shader_material_instance := preload("res://shaders/panel_shader_material.tres")

var fullscreen := true
var vsync = null
var fps_max := 60
var ui_blur := true
var ui_scaling := 1.0

var touchscreen_mode := false
var touchscreen_control := TouchscreenControlMode.TAP
var keyboard_up := KEY_W
var keyboard_down := KEY_S
var gamepad_deadzone := 0.3
var telemetry := false

var volume := [1.0, 0.8, 1.0, 0.5, 1.0]
var vsync_availability := [null, null, null, null]

var dev_console := false
# These values aren't saved
var dev_error_sounds := false
var dev_show_errors := false
# ------------------------
var dev_show_fps := false

# Carride specific options || These values aren't saved
var cr_speedometer_label := false

var narrator_speaking := false
var reduced_motion := false
var easier_font := false

var skip_intro := false
var skip_boot := false

var cheats := false
var godmode := false

var cfg_window_mode := DisplayServer.WINDOW_MODE_WINDOWED
var cfg_rendering_method := "gl_compatibility"
var cfg_linux_window_system := "x11"
var cfg = ConfigFile.new()


func load_config() -> bool:
	if not FileAccess.file_exists("user://config.cfg"):
		first_boot = true
		save_config()
		return true
	var file = FileAccess.open("user://config.cfg", FileAccess.READ)
	var json_data = file.get_line()
	var json = JSON.new() # Helper
	var parse_result = json.parse(json_data)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(),
				" in ", json_data, " at line ", json.get_error_line())
		return false
	var data: Dictionary = json.get_data()

	fullscreen = validate_data(data, "fullscreen", fullscreen)
	vsync = validate_data(data, "vsync", vsync)
	fps_max = validate_data(data, "fps_max", fps_max)
	ui_scaling = validate_data(data, "ui_scaling", ui_scaling)
	ui_blur = validate_data(data, "ui_blur", ui_blur)

	volume[AudioBus.MASTER] = validate_data(data, "master_volume", volume[AudioBus.MASTER])
	volume[AudioBus.SFX] = validate_data(data, "sfx_volume", volume[AudioBus.SFX])
	volume[AudioBus.VOICE] = validate_data(data, "voice_volume", volume[AudioBus.VOICE])
	volume[AudioBus.MUSIC] = validate_data(data, "music_volume", volume[AudioBus.MUSIC])
	volume[AudioBus.NARRATOR] = validate_data(data, "narrator_volume", volume[AudioBus.NARRATOR])

	narrator_speaking = validate_data(data, "narrator_speaking", narrator_speaking)

	skip_intro = validate_data(data, "skip_intro", skip_intro)
	skip_boot = validate_data(data, "skip_boot", skip_boot)

	reduced_motion = validate_data(data, "reduced_motion", reduced_motion)
	easier_font = validate_data(data, "easier_font", easier_font)
	touchscreen_mode = validate_data(data, "touchscreen_mode", touchscreen_mode)
	touchscreen_control = validate_data(data, "touchscreen_control", touchscreen_control)
	gamepad_deadzone = validate_data(data, "gamepad_deadzone", gamepad_deadzone)
	telemetry = validate_data(data, "telemetry", telemetry)
	keyboard_up = validate_data(data, "keyboard_up", keyboard_up)
	keyboard_down = validate_data(data, "keyboard_down", keyboard_down)

	dev_console = validate_data(data, "dev_console", dev_console)
	dev_show_fps = validate_data(data, "dev_show_fps", dev_show_fps)

	save_config()
	return true


func validate_data(data: Dictionary, value: String, old_value):
	if value in data.keys():
		return data[value]
	return old_value


func save_config():
	var file = FileAccess.open("user://config.cfg", FileAccess.WRITE)
	var config_dict = {
		"fullscreen": fullscreen,
		"vsync": vsync,
		"fps_max": fps_max,
		"ui_scaling": ui_scaling,
		"ui_blur": ui_blur,
		"master_volume": volume[AudioBus.MASTER],
		"sfx_volume": volume[AudioBus.SFX],
		"voice_volume": volume[AudioBus.VOICE],
		"music_volume": volume[AudioBus.MUSIC],
		"narrator_volume": volume[AudioBus.NARRATOR],
		"narrator_speaking": narrator_speaking,
		"skip_intro": skip_intro,
		"skip_boot": skip_boot,
		"dev_console": dev_console,
		"dev_show_fps": dev_show_fps,
		"reduced_motion": reduced_motion,
		"easier_font": easier_font,
		"touchscreen_mode": touchscreen_mode,
		"touchscreen_control": touchscreen_control,
		"gamepad_deadzone": gamepad_deadzone,
		"keyboard_up": keyboard_up,
		"keyboard_down": keyboard_down,
		"telemetry": telemetry
	}
	var json = JSON.stringify(config_dict)
	file.store_line(json)
	save_override()


func load_override():
	var err = cfg.load("user://override.cfg")
	if err != OK:
		cfg_window_mode = DisplayServer.WINDOW_MODE_WINDOWED
		cfg_rendering_method = "gl_compatibility"
		return
	cfg_window_mode = cfg.get_value("display", "window/size/mode")
	cfg_rendering_method = cfg.get_value("rendering", "renderer/rendering_method")
	if cfg.has_section_key("display", "display_server/driver.linuxbsd"):
		cfg_linux_window_system = cfg.get_value("display", "display_server/driver.linuxbsd")
	if cfg.has_section_key("display", "window/vsync/vsync_mode"):
		vsync = cfg.get_value("display", "window/vsync/vsync_mode")
	if cfg.has_section_key("application", "run/max_fps"):
		fps_max = cfg.get_value("application", "run/max_fps")


func save_override():
	cfg.set_value("display", "window/size/mode", cfg_window_mode)
	cfg.set_value("rendering", "renderer/rendering_method", cfg_rendering_method)
	cfg.set_value("rendering", "renderer/rendering_method.mobile", cfg_rendering_method)
	cfg.set_value("display", "window/vsync/vsync_mode", vsync)
	cfg.set_value("display", "display_server/driver.linuxbsd", cfg_linux_window_system)
	cfg.set_value("application", "run/max_fps", fps_max)
	cfg.save("user://override.cfg")


func _enter_tree():
	load_override()
	var result = load_config()

	if result == false:
		show_os_alert("ERROR WHILE LOADING A CONFIG FILE", "Couldn't load a config file.\n" +
				"Game will start with default settings and override the config file."
		)
		set_default_ui_scale()
		save_config()

	_initialize_settings()
	_initialize_debug_settings()
	_configure_silentwolf()
	print("DEVICE ID: %s" % OS.get_unique_id())

	if OS.get_name() == "Linux":
		if cfg_linux_window_system.to_lower() == "wayland" && \
				DisplayServer.get_name().to_lower() != "wayland":
			show_os_alert("WAYLAND INITIALIZATION ERROR", "Couldn't start a Wayland client\n" +
				"Game will run in X11 mode."
			)
	if OS.get_name() == "Android":
		touchscreen_mode = true # Enforce touchscreen mode for android devices


func _initialize_settings():
	for bus in AudioBus.values():
		set_audio_volume(bus, volume[bus])

	get_tree().root.content_scale_factor = ui_scaling

	var window_mode = (
		DisplayServer.WINDOW_MODE_FULLSCREEN if SettingsBus.fullscreen
		else DisplayServer.WINDOW_MODE_WINDOWED
		)
	DisplayServer.window_set_mode(window_mode)

	await _check_vsync_availability()
	DisplayServer.window_set_vsync_mode(SettingsBus.vsync)
	if (SettingsBus.vsync == DisplayServer.VSYNC_DISABLED or
		SettingsBus.vsync == DisplayServer.VSYNC_MAILBOX
	):
		Engine.max_fps = SettingsBus.fps_max
	else:
		Engine.max_fps = 0

	set_ui_shader(ui_blur)

	if not narrator_speaking:
		set_audio_volume(AudioBus.NARRATOR, 0.0)

	if easier_font:
		ThemeDB.get_project_theme().set_default_font(load("res://theme/fonts/OpenDyslexic-Regular.otf"))

	if OS.get_name() == "Android":
		OS.request_permission("MANAGE_EXTERNAL_STORAGE")
		touchscreen_mode = true

	var event = null
	for action in ["move_up", "move_down"]:
		event = InputEventKey.new()
		event.keycode = keyboard_up if action == "move_up" else keyboard_down
		InputMap.action_erase_event(action, InputMap.action_get_events(action)[2])
		InputMap.action_add_event(action, event)


func _initialize_debug_settings():
	if OS.has_feature("private-test"):
		dev_console = true
		dev_error_sounds = true
		dev_show_errors = true
		dev_show_fps = true
	if OS.is_debug_build():
		dev_console = true
		dev_error_sounds = true
		dev_show_errors = true
		dev_show_fps = true
		cr_speedometer_label = true


func _check_vsync_availability() -> void:
	await get_tree().process_frame
	# Yup, GDScript cannot iterate through enums... sad...
	var vsyncs = [
		DisplayServer.VSYNC_DISABLED,
		DisplayServer.VSYNC_ENABLED,
		DisplayServer.VSYNC_ADAPTIVE,
		DisplayServer.VSYNC_MAILBOX,
	]
	for v in vsyncs:
		DisplayServer.window_set_vsync_mode(v)
		await get_tree().process_frame
		if DisplayServer.window_get_vsync_mode() == v:
			vsync_availability[v] = true
		else:
			vsync_availability[v] = false
	if vsync == null:
		vsync = _vsync_set_by_priority()
	SignalBus.vsync_checked.emit()


func _vsync_set_by_priority() -> DisplayServer.VSyncMode:
	if vsync_availability[DisplayServer.VSYNC_MAILBOX]:
		return DisplayServer.VSYNC_MAILBOX
	if vsync_availability[DisplayServer.VSYNC_ADAPTIVE]:
		return DisplayServer.VSYNC_ADAPTIVE
	if vsync_availability[DisplayServer.VSYNC_ENABLED]:
		return DisplayServer.VSYNC_ENABLED
	return DisplayServer.VSYNC_DISABLED


func show_os_alert(console_title: String, message: String):
	print(" ========== " + console_title + " ========== ")
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = load("res://audio/sfx/chord.wav")
	player.play()
	player.finished.connect(func(): player.queue_free())
	OS.alert(message, "ERROR")


func set_audio_volume(bus: AudioBus, vol: float):
	volume[bus] = vol
	AudioServer.set_bus_volume_db(bus, linear_to_db(vol)*2)


func set_ui_shader(yes: bool):
	if yes:
		ui_shader_material_instance.shader = load("res://shaders/panel.gdshader")
	else:
		ui_shader_material_instance.shader = null
	ui_blur = yes
	# ui_shader_material_instance.set_shader_parameter("apply", ui_blur)



func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SettingsBus.save_config()


func _configure_silentwolf():
	SilentWolf.configure({
		"api_key": Marshalls.base64_to_utf8(API_KEY).strip_escapes(),
		"game_id": "slbljpm",
		"log_level": 2 if OS.is_debug_build() else 0,
		"max_scores": 500
	})
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/mainMenu.tscn"
	})


func set_default_ui_scale():
	if OS.get_name() == "Android":
		ui_scaling = 1.2
	else:
		ui_scaling = 1.0


func modify_keybindings(action, key):
	match(action):
		"move_up":
			keyboard_up = key
			print(action)
		"move_down":
			keyboard_down = key
			print(action)
		_:
			push_error("Unknown action! Can't set keybinding!")
