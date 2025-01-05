extends CanvasLayer


@onready var PlayerNameEdit := $"Panel/VBoxContainer/HBoxContainer/PlayerNameEdit"
@onready var PlayerUUID := $"Panel/VBoxContainer/HBoxContainer/PlayerUUID"

signal save_button


func _ready():
	var uuid = SettingsBus.playername.split("#")[1]
	PlayerUUID.text = "#" + uuid


func _on_save_button_pressed():
	SettingsBus.playername = PlayerNameEdit.text.replace("\n", "") + SettingsBus.playername.right(9)
	hide()
	save_button.emit()
