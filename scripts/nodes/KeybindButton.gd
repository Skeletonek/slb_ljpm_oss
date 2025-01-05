extends Button
class_name KeybindButton

@export var action: String


func _init():
	toggle_mode = true
	theme_type_variation = "KeybindButton"


func _ready():
	set_process_unhandled_input(false)
	update_key_text()


func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "..."
		release_focus()
	else:
		update_key_text()
		grab_focus()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			InputMap.action_erase_event(action, InputMap.action_get_events(action)[2])
			InputMap.action_add_event(action, event)
			SettingsBus.modify_keybindings(action, event.keycode)
			button_pressed = false


func update_key_text():
	text = "%s" % InputMap.action_get_events(action)[2].as_text()
