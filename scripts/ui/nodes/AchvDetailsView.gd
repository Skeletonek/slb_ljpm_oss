extends CanvasLayer


@onready var icon = $PanelContainer/MarginContainer/HBoxContainer/AchvDetailsIcon
@onready var title = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/AchvDetailsTitle
@onready var desc = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/AchvDetailsDesc
@onready var date = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/AchvDetailsDate
@onready var close_button = $PanelContainer/MarginContainer/CloseButton


func _on_close_button_pressed():
	visible = false
	get_parent().back_button.grab_focus()
