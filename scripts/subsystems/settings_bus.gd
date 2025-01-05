extends Node

const DESKTOP_PLATFORM = ["Windows", "UWP", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD"]

var master_volume := 1.0
var sfx_volume := 0.8
var voice_volume := 1.0
var music_volume := 0.5
var narrator_volume := 1.0
var ui_scaling := 1.0
var fullscreen := true
var narrator_speaking := false
var skip_intro := false

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
		var data = json.get_data()

		master_volume = data["master_volume"]
		sfx_volume = data["sfx_volume"]
		voice_volume = data["voice_volume"]
		music_volume = data["music_volume"]
		narrator_volume = data["narrator_volume"]
		ui_scaling = data["ui_scaling"]
		fullscreen = data["fullscreen"]
		narrator_speaking = data["narrator_speaking"]
		skip_intro = data["skip_intro"]
		return true


func save_config():
	var file = FileAccess.open("user://config.cfg", FileAccess.WRITE)
	var config_dict = {
		"master_volume": master_volume,
		"sfx_volume": sfx_volume,
		"voice_volume": voice_volume,
		"music_volume": music_volume,
		"narrator_volume": narrator_volume,
		"ui_scaling": ui_scaling,
		"narrator_speaking": narrator_speaking,
		"fullscreen": fullscreen,
		"skip_intro": skip_intro
	}
	var json = JSON.stringify(config_dict)
	file.store_line(json)


func load_override():
	var err = cfg.load("override.cfg")
	if err != OK:
		cfg_window_mode = DisplayServer.WINDOW_MODE_WINDOWED
		cfg_rendering_method = "gl_compatibility"
		return
	cfg_window_mode = cfg.get_value("display", "window/size/mode")
	cfg_rendering_method = cfg.get_value("rendering", "renderer/rendering_method")


func save_override():
	cfg.set_value("display", "window/size/mode", cfg_window_mode)
	cfg.set_value("rendering", "renderer/rendering_method", cfg_rendering_method)
	cfg.set_value("rendering", "renderer/rendering_method.mobile", cfg_rendering_method)
	cfg.save("override.cfg")


func _enter_tree():
	load_override()
	var result = load_config()
	if result == false:
		print(" ========== ERROR WHILE LOADING A CONFIG FILE ========== ")
		OS.alert("Couldn't load a config file.\n" +
				 "Game will start with default settings and override the config file.",
				 "ERROR")
		set_default_ui_scale()
		save_config()

	_initialize_settings()


func _initialize_settings():
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume)*2)
	AudioServer.set_bus_volume_db(1, linear_to_db(sfx_volume)*2)
	AudioServer.set_bus_volume_db(2, linear_to_db(voice_volume)*2)
	AudioServer.set_bus_volume_db(3, linear_to_db(music_volume)*2)
	get_tree().root.content_scale_factor = ui_scaling
	if narrator_speaking:
		AudioServer.set_bus_volume_db(4, linear_to_db(narrator_volume)*2)
	else:
		AudioServer.set_bus_volume_db(4, linear_to_db(0))


func set_default_ui_scale():
	if OS.get_name() == "Android":
		ui_scaling = 1.2
	else:
		ui_scaling = 1.0
