extends Node

const DESKTOP_PLATFORM = ["Windows", "UWP", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD"]
enum TOUCHSCREEN_CONTROL_MODE {Tap, Swipe, VButtons}

var master_volume := 1.0
var sfx_volume := 0.8
var voice_volume := 1.0
var music_volume := 0.5
var narrator_volume := 1.0

var ui_scaling := 1.0
var fullscreen := true

var touchscreen_control := TOUCHSCREEN_CONTROL_MODE.Tap
var keyboard_up := KEY_W
var keyboard_down := KEY_S
var playername := "Player#" + OS.get_unique_id().substr(0, 8)
var dev_console := false

var narrator_speaking := false
var reduced_motion := false
var easier_font := false

var skip_intro := false

var godmode: = false

var cfg_window_mode := DisplayServer.WINDOW_MODE_WINDOWED
var cfg_rendering_method := "mobile"
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
		reduced_motion = data["reduced_motion"]
		easier_font = data["easier_font"]
		touchscreen_control = data["touchscreen_control"]
		keyboard_up = data["keyboard_up"]
		keyboard_down = data["keyboard_down"]
		playername = data["playername"]
		dev_console = data["dev_console"]
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
		"skip_intro": skip_intro,
		"reduced_motion": reduced_motion,
		"easier_font": easier_font,
		"touchscreen_control": touchscreen_control,
		"keyboard_up": keyboard_up,
		"keyboard_down": keyboard_down,
		"playername": playername,
		"dev_console": dev_console
	}
	var json = JSON.stringify(config_dict)
	file.store_line(json)


func load_override():
	var err = cfg.load("user://override.cfg")
	if err != OK:
		cfg_window_mode = DisplayServer.WINDOW_MODE_WINDOWED
		cfg_rendering_method = "mobile"
		return
	cfg_window_mode = cfg.get_value("display", "window/size/mode")
	cfg_rendering_method = cfg.get_value("rendering", "renderer/rendering_method")


func save_override():
	cfg.set_value("display", "window/size/mode", cfg_window_mode)
	cfg.set_value("rendering", "renderer/rendering_method", cfg_rendering_method)
	cfg.set_value("rendering", "renderer/rendering_method.mobile", cfg_rendering_method)
	cfg.save("user://override.cfg")


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
	_configure_silentwolf()


func _initialize_settings():
	print(OS.get_model_name())
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume)*2)
	AudioServer.set_bus_volume_db(1, linear_to_db(sfx_volume)*2)
	AudioServer.set_bus_volume_db(2, linear_to_db(voice_volume)*2)
	AudioServer.set_bus_volume_db(3, linear_to_db(music_volume)*2)
	get_tree().root.content_scale_factor = ui_scaling
	if narrator_speaking:
		AudioServer.set_bus_volume_db(4, linear_to_db(narrator_volume)*2)
	else:
		AudioServer.set_bus_volume_db(4, linear_to_db(0))
	if easier_font:
		ThemeDB.get_project_theme().set_default_font(load("res://theme/fonts/OpenDyslexic-Regular.otf"))
	var event = null
	for action in ["move_up", "move_down"]:
		event = InputEventKey.new()
		event.keycode = keyboard_up if action == "move_up" else keyboard_down
		InputMap.action_erase_event(action, InputMap.action_get_events(action)[2])
		InputMap.action_add_event(action, event)


func _configure_silentwolf():
	SilentWolf.configure({
		"api_key": "",
		"game_id": "slbljpm",
		"log_level": 2
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
