extends CanvasLayer

var download_url: String

@onready var version_label := $"Panel/VBoxContainer/HBoxContainer2/VersionLabel"
@onready var changelog := $"Panel/VBoxContainer/ScrollContainer/Changelog"


func update_version_data(version, url):
	version_label.text = version
	download_url = url


func update_changelog_data(data):
	changelog.text = data


func _on_back_button_pressed():
	hide()


func _on_update_button_pressed():
	print("Redirecting to the update download URL...")
	OS.shell_open(download_url)
	SettingsBus.save_config()
	print("The game will now close!")
	get_tree().quit()
