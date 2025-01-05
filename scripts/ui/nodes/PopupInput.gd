extends CanvasLayer

signal save_button

@onready var player_name_edit := $"Panel/VBoxContainer/HBoxContainer/PlayerNameEdit"
@onready var player_uuid := $"Panel/VBoxContainer/HBoxContainer/PlayerUUID"


func _ready():
	player_uuid.text = "#" + ProfileBus.profile.machineid


func _on_save_button_pressed():
	ProfileBus.profile.change_playername(player_name_edit.text)
	hide()
	save_button.emit()
