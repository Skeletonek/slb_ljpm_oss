extends CanvasLayer


@onready var icon = $PanelContainer/MarginContainer/HBoxContainer/AchvDetailsIcon
@onready var title = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/AchvDetailsTitle
@onready var desc = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/AchvDetailsDesc
@onready var date = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/AchvDetailsDate

func _on_close_button_pressed():
	visible = false
