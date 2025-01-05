class_name SwitchButton extends Button

func _ready():
	pass

func _toggled(button_pressed):
	if button_pressed:
		text = "Włączony"
	else:
		text = "Wyłączony"
