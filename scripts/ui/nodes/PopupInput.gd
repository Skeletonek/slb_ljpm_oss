extends CanvasLayer

signal save_button

@onready var player_name_edit := $"Panel/VBoxContainer/HBoxContainer/PlayerNameEdit"
@onready var player_uuid := $"Panel/VBoxContainer/HBoxContainer/PlayerUUID"



func _ready():
	var uuid = SettingsBus.playername.split("#")[1]
	player_uuid.text = "#" + uuid


func _on_save_button_pressed():
	SettingsBus.playername = player_name_edit.text.replace("\n", "") + SettingsBus.playername.right(9)
	hide()
	save_button.emit()
