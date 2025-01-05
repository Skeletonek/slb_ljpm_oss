extends CanvasLayer

@onready var VersionLabel := $"Panel/VBoxContainer/HBoxContainer2/VersionLabel"
@onready var Changelog := $"Panel/VBoxContainer/ScrollContainer/Changelog"
var download_url: String


func update_version_data(version, url):
	VersionLabel.text = version
	download_url = url


func update_changelog_data(changelog):
	Changelog.text = changelog


func _on_back_button_pressed():
	hide()


func _on_update_button_pressed():
	print("Redirecting to the update download URL...")
	OS.shell_open(download_url)
	SettingsBus.save_config()
	print("The game will now close!")
	get_tree().quit()
