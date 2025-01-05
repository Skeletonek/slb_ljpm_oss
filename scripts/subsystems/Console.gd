extends CanvasLayer

const SUPPORTED_COMMANDS = {
	1: "achievement_award",
	2: "achievement_reset",
	3: "help",
	4: "start_timeline",
	5: "gamemap",
	6: "quit",
	7: "enable_dev_buttons",
	8: "timelines",
	9: "music_play",
	10: "music_list",
	11: "carride",
	12: "god"
}

signal error_msg_received(msg:String)
signal warning_msg_received(msg:String)
signal info_msg_received(msg:String)

const UPDATE_INTERVAL := 0.1
const ERROR_MSG_PREFIX := "USER ERROR: "
const WARNING_MSG_PREFIX := "USER WARNING: "
const COMMAND_MSG_PREFIX := "DEV PROMPT: "
#Any logs with three spaces at the beginning will be ignored.
const IGNORE_PREFIX := "   " 

var godot_log

@onready var log_rich_label = $PanelContainer/MarginContainer/VBoxContainer/LogRichLabel
@onready var prompt_edit = $PanelContainer/MarginContainer/VBoxContainer/PromptEdit
# Called when the node enters the scene tree for the first time.
func _ready():
	godot_log = FileAccess.open("user://logs/godot.log", FileAccess.READ)
	
	create_tween().set_loops(
	).tween_callback(_read_data
	).set_delay(UPDATE_INTERVAL)
	
	if OS.get_name() == "Android" && OS.is_debug_build():
		$AndroidLayer.show()


func _read_data():
	while godot_log.get_position() < godot_log.get_length():
		var new_line = godot_log.get_line()
		if new_line.begins_with(IGNORE_PREFIX):
			continue
		if new_line.begins_with(ERROR_MSG_PREFIX):
			log_rich_label.append_text("[color=red][ERR] " + 
			new_line.trim_prefix(ERROR_MSG_PREFIX) + "[/color]")
		elif new_line.begins_with(WARNING_MSG_PREFIX):
			log_rich_label.append_text("[color=orange][WRN] " + 
			new_line.trim_prefix(WARNING_MSG_PREFIX) + "[/color]")
		elif new_line.begins_with(COMMAND_MSG_PREFIX):
			log_rich_label.append_text("[color=darkgray][CMD] " + 
			new_line.trim_prefix(COMMAND_MSG_PREFIX) + "[/color]")
		else:
			log_rich_label.append_text("[LOG] " + new_line)
		log_rich_label.append_text("\n")


func _input(event):
	if event.is_action("console_toggle"):
		prompt_edit.clear()
	if event.is_action_pressed("console_toggle"):
		visible = !visible
		if visible:
			prompt_edit.grab_focus()
	elif event.is_action_pressed("console_autocomplete"):
		if visible:
			for x in SUPPORTED_COMMANDS.values():
				if x.begins_with(prompt_edit.text):
					prompt_edit.text = x
					prompt_edit.caret_column = prompt_edit.text.length()
					break


func _on_show_button_pressed():
	visible = !visible
	if visible:
		prompt_edit.grab_focus()


func _get_all_timelines():
	var dir = DirAccess.open("res://dialogic/timelines")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				print(file_name)
			file_name = dir.get_next()


func _get_all_musicfiles():
	var dir = DirAccess.open("res://music")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and not file_name.ends_with(".import"):
				print(file_name)
			file_name = dir.get_next()


func _on_prompt_edit_text_submitted(new_text):
	print("DEV PROMPT: " + new_text)
	prompt_edit.grab_focus()
	var command = new_text.split(" ")
	match(command[0]):
		SUPPORTED_COMMANDS[1]:
			push_error("Unsupported command")
		SUPPORTED_COMMANDS[2]:
			push_error("Unsupported command")
		SUPPORTED_COMMANDS[3]:
			var commands_sorted = SUPPORTED_COMMANDS.values()
			commands_sorted.sort()
			print(str(commands_sorted).replace(", ", "\n").trim_prefix("[").trim_suffix("]"))
		SUPPORTED_COMMANDS[4]:
			if command.size() < 2:
				_get_all_timelines()
			else:
				if not command[1].ends_with(".dtl"):
					command[1] += ".dtl"
				print("Starting " + command[1])
				get_tree().change_scene_to_file("res://scenes/a1_br.tscn")
				SignalBus.dialogic_path = "res://dialogic/timelines/" + command[1]
		SUPPORTED_COMMANDS[5]:
			get_tree().change_scene_to_file("res://scenes/testScene.tscn")
		SUPPORTED_COMMANDS[6]:
			get_tree().quit()
		SUPPORTED_COMMANDS[7]:
			var node = get_node("/root/mainMenu")
			node.emit_signal("DEBUG_DEV_BUTTONS")
		SUPPORTED_COMMANDS[8]:
			_get_all_timelines()
		SUPPORTED_COMMANDS[9]:
			if command.size() < 2:
				_get_all_musicfiles()
			else:
				if not command[1].ends_with(".ogg"):
					command[1] += ".ogg"
				print("Playing " + command[1])
				GlobalMusic.stream = load("res://music/" + command[1])
				GlobalMusic.play()
		SUPPORTED_COMMANDS[10]:
			_get_all_musicfiles()
		SUPPORTED_COMMANDS[11]:
			get_tree().change_scene_to_file("res://scenes/carride.tscn")
		SUPPORTED_COMMANDS[12]:
			SettingsBus.godmode = !SettingsBus.godmode
			print("Godmode " + ("enabled" if SettingsBus.godmode else "disabled"))
		_:
			push_error("Unknown command")
	prompt_edit.clear()

