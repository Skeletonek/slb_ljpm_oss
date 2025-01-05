class_name SwitchButton extends Button

func _ready():
	pass

func _toggled(button_pressed):
	_change_text(button_pressed)

## This functions does the same as [method BaseButton.set_pressed_no_signal] but also changes text according to [code]pressed[/code] state
func set_pressed_no_signal_custom(pressed: bool):
	_change_text(pressed)
	set_pressed_no_signal(pressed)

func _change_text(status):
	if status:
		text = "Włączony"
	else:
		text = "Wyłączony"
