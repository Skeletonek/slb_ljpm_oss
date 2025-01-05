extends Node

const DESKTOP_PLATFORM = ["Windows", "UWP", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD"]
const API_KEY = ""
enum TOUCHSCREEN_CONTROL_MODE {
	Tap,
	Swipe,
	VButtons
}

enum AudioBus {
	Master,
	SFX,
	Voice,
	Music,
	Narrator
}

var os_id = 1 if OS.get_name() == "Windows" else 0

var ui_shader_material_instance := preload("res://shaders/panel_shader_material.tres")

var fullscreen := true
var vsync := DisplayServer.VSYNC_ADAPTIVE
var fps_max := 60
var ui_blur := true
var ui_scaling := 1.0

var touchscreen_control := TOUCHSCREEN_CONTROL_MODE.Tap
var keyboard_up := KEY_W
var keyboard_down := KEY_S
var playername := "#" + OS.get_unique_id().substr(os_id, 8)

var volume := [1.0, 0.8, 1.0, 0.5, 1.0]

var dev_console := false
# These values aren't saved
var dev_error_sounds := false
var dev_show_errors := false
# ------------------------
var dev_show_fps := false

var narrator_speaking := false
var reduced_motion := false
var easier_font := false

var skip_intro := false
var skip_boot := false

var cheats := false
var godmode := false

var cfg_window_mode := DisplayServer.WINDOW_MODE_WINDOWED
var cfg_rendering_method := "gl_compatibility"
var cfg = ConfigFile.new()

func load_config() -> bool:
	if not FileAccess.file_exists("user://config.cfg"):
		save_config()
		return true
	else:
		var file = FileAccess.open("user://config.cfg", FileAccess.READ)
		var json_data = file.get_line()
		var json = JSON.new() # Helper
		var parse_result = json.parse(json_data)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_data, " at line ", json.get_error_line())
			return false
		var data: Dictionary = json.get_data()

		fullscreen = data["fullscreen"]
		vsync = data["vsync"] if data.has("vsync") else vsync
		fps_max = data["fps_max"] if data.has("fps_max") else fps_max
		ui_scaling = data["ui_scaling"]
		ui_blur = data["ui_blur"] if data.has("ui_blur") else ui_blur

		volume[AudioBus.Master] = data["master_volume"]
		volume[AudioBus.SFX] = data["sfx_volume"]
		volume[AudioBus.Voice] = data["voice_volume"]
		volume[AudioBus.Music] = data["music_volume"]
		volume[AudioBus.Narrator] = data["narrator_volume"]

		narrator_speaking = data["narrator_speaking"]

		skip_intro = data["skip_intro"]
		skip_boot = data["skip_boot"] if data.has("skip_boot") else skip_boot

		reduced_motion = data["reduced_motion"]
		easier_font = data["easier_font"]
		touchscreen_control = data["touchscreen_control"]
		keyboard_up = data["keyboard_up"]
		keyboard_down = data["keyboard_down"]
		playername = data["playername"]

		dev_console = data["dev_console"]
		dev_show_fps = data["dev_show_fps"] if data.has("dev_show_fps") else dev_show_fps

		if playername.length() > 44:
			var playername_split = playername.split('#')
			playername = playername_split[0].substr(0,36) + '#' + playername_split[1]
		save_config()
		return true


func save_config():
	var file = FileAccess.open("user://config.cfg", FileAccess.WRITE)
	var config_dict = {
		"fullscreen": fullscreen,
		"vsync": vsync,
		"fps_max": fps_max,
		"ui_scaling": ui_scaling,
		"ui_blur": ui_blur,
		"master_volume": volume[AudioBus.Master],
		"sfx_volume": volume[AudioBus.SFX],
		"voice_volume": volume[AudioBus.Voice],
		"music_volume": volume[AudioBus.Music],
		"narrator_volume": volume[AudioBus.Narrator],
		"narrator_speaking": narrator_speaking,
		"skip_intro": skip_intro,
		"skip_boot": skip_boot,
		"dev_console": dev_console,
		"dev_show_fps": dev_show_fps,
		"reduced_motion": reduced_motion,
		"easier_font": easier_font,
		"touchscreen_control": touchscreen_control,
		"keyboard_up": keyboard_up,
		"keyboard_down": keyboard_down,
		"playername": playername,
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
	if cfg.has_section_key("display", "window/vsync/vsync_mode"):
		vsync = cfg.get_value("display", "window/vsync/vsync_mode")
	if cfg.has_section_key("application", "run/max_fps"):
		fps_max = cfg.get_value("application", "run/max_fps")


func save_override():
	cfg.set_value("display", "window/size/mode", cfg_window_mode)
	cfg.set_value("rendering", "renderer/rendering_method", cfg_rendering_method)
	cfg.set_value("rendering", "renderer/rendering_method.mobile", cfg_rendering_method)
	cfg.set_value("display", "window/vsync/vsync_mode", vsync)
	cfg.set_value("application", "run/max_fps", fps_max)
	cfg.save("user://override.cfg")


func _enter_tree():
	load_override()
	var result = load_config()
	
	if result == false:
		show_os_alert("ERROR WHILE LOADING A CONFIG FILE", "Couldn't load a config file.\n" +
				 "Game will start with default settings and override the config file.")
		set_default_ui_scale()
		save_config()
	
	_initialize_settings()
	_initialize_debug_settings()
	_configure_silentwolf()
	print("DEVICE ID: %s" % OS.get_unique_id())

	if OS.get_name() != "Android" and not OS.has_feature("editor"):
		var audioload = ProjectSettings.load_resource_pack("res://Resources/SLB2_Audio.pck")
		var videoload = ProjectSettings.load_resource_pack("res://Resources/SLB2_Video.pck")
		var graphicsload = ProjectSettings.load_resource_pack("res://Resources/SLB2_Graphics.pck")
		if not audioload or not videoload or not graphicsload:
			show_os_alert("MISSING RESOURCES", "Missing resources.\n" +
					 "Check if you have all necessary resources installed inside the Resources directory.\n" +
					 "The game will terminate.")
			get_tree().quit(404)


func _initialize_settings():
	for bus in AudioBus.values():
		set_audio_volume(bus, volume[bus])
	get_tree().root.content_scale_factor = ui_scaling
	DisplayServer.window_set_vsync_mode(SettingsBus.vsync)
	var window_mode = (
		DisplayServer.WINDOW_MODE_FULLSCREEN if SettingsBus.fullscreen
		else DisplayServer.WINDOW_MODE_WINDOWED
		)
	DisplayServer.window_set_mode(window_mode)
	set_ui_shader(ui_blur)
	if SettingsBus.vsync == DisplayServer.VSYNC_DISABLED or SettingsBus.vsync == DisplayServer.VSYNC_MAILBOX:
		Engine.max_fps = SettingsBus.fps_max
	else:
		Engine.max_fps = 0
	if not narrator_speaking:
		set_audio_volume(AudioBus.Narrator, 0.0)
	if easier_font:
		ThemeDB.get_project_theme().set_default_font(load("res://theme/fonts/OpenDyslexic-Regular.otf"))
	var event = null
	for action in ["move_up", "move_down"]:
		event = InputEventKey.new()
		event.keycode = keyboard_up if action == "move_up" else keyboard_down
		InputMap.action_erase_event(action, InputMap.action_get_events(action)[2])
		InputMap.action_add_event(action, event)


func _initialize_debug_settings():
	if OS.is_debug_build():
		dev_console = true
		dev_error_sounds = true
		dev_show_errors = true
		dev_show_fps = true


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
	ui_blur = yes
	ui_shader_material_instance.set_shader_parameter("apply", ui_blur)



func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SettingsBus.save_config()


func _configure_silentwolf():
	SilentWolf.configure({
		"api_key": Marshalls.base64_to_utf8(API_KEY).strip_escapes(),
		"game_id": "slbljpm",
		"log_level": 2 if OS.is_debug_build() else 1,
		"max_scores": 1000
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
