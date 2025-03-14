extends Control

enum {
	ACHV_NAME,
	ACHV_DESC,
	ACHV_ICON,
	ACHV_HIDDEN
}

enum {
	ACHV_COMPLETE,
	ACHV_DATE,
}

const ACHV_FILE = "user://achievements.dat"

var data: Dictionary
var completed: Dictionary
var recently_completed: Dictionary

@onready var achievement_panel := $CanvasLayer/AchievementPanelContainer
@onready var achievement_panel2 := $CanvasLayer/AchievementPanelContainer2
@onready var achievement_panel3 := $CanvasLayer/AchievementPanelContainer3
@onready var achievement_list := $AchvList
# var achievements_delay_timer := Timer.new()

func _ready() -> void:
	data = achievement_list.ACHIEVEMENT_LIST
	completed = _generate_achv_completed_array()
	recently_completed = _generate_achv_recently_completed_array()
	if not load_achievements():
		if FileAccess.file_exists(ACHV_FILE):
			SettingsBus.show_os_alert("ERROR WHILE LOADING ACHIEVEMENTS FILE",
				"Couldn't load achievements file.\n" +
				"All achievements will be erased!\n" +
				"Terminate the game now if you don't want to override your achievements file!"
			)
		save_achievements()


func load_achievements() -> bool:
	if not FileAccess.file_exists(ACHV_FILE):
		return false
	var file = FileAccess.open(ACHV_FILE, FileAccess.READ)
	var dat = file.get_var(true)
	file.close()
# Old JSON loading
#	var file = FileAccess.open(ACHV_FILE, FileAccess.READ)
#	var json_data = file.get_line()
#	var json = JSON.new() # Helper
#	var parse_result = json.parse(json_data)
#	if not parse_result == OK:
#		print("JSON Parse Error: ", json.get_error_message(), " in ",
#				json_data, " at line ", json.get_error_line())
#		return false
#	var dat = json.get_data()

	for x in dat:
		completed[x] = dat[x]
	return true


func save_achievements() -> void:
	var file = FileAccess.open(ACHV_FILE, FileAccess.WRITE)
	file.store_var(completed, true)
	file.close()
# Old JSON saving
#	var file = FileAccess.open(ACHV_FILE, FileAccess.WRITE)
#	var json = JSON.stringify(achievement_completed)
#	file.store_line(json)


func _generate_achv_completed_array() -> Dictionary:
	var dict = {}
	var arr = [false, "n/a"]
	for x in data:
		dict[x] = arr.duplicate()
	return dict


func _generate_achv_recently_completed_array() -> Dictionary:
	var dict = {}
	for x in data:
		dict[x] = false
	return dict


func call_achievement(achievement: String) -> bool:
	if completed[achievement][ACHV_COMPLETE]:
		return true
	if SettingsBus.cheats:
		return false

	completed[achievement][ACHV_COMPLETE] = true
	completed[achievement][ACHV_DATE] = Time.get_datetime_string_from_system(false, true)
	recently_completed[achievement] = true
	save_achievements()
	_play_achievement(achievement)
	SignalBus.emit_signal("refresh_achievements_viewer")

	print("EARNED ACHIEVEMENT: {TITLE:",
	data[achievement][ACHV_NAME],", DESCRIPTION:",
	data[achievement][ACHV_DESC],"}")
	return true


func _play_achievement(achievement: String) -> void:
	# achievements_delay_timer.stop()
	if achievement_panel.animation_state == achievement_panel.IDLE:
		achievement_panel.show_achievement(
			data[achievement]
			)
	elif achievement_panel2.animation_state == achievement_panel.IDLE:
		achievement_panel2.show_achievement(
			data[achievement]
			)
	elif achievement_panel3.animation_state == achievement_panel.IDLE:
		achievement_panel3.show_achievement(
			data[achievement]
			)
	else:
		await get_tree().create_timer(7).timeout
		_play_achievement(achievement)


func debug_award_achv_all() -> void:
	for x in data:
		call_achievement(x)


func debug_reset_test_achv_all() -> void:
	for x in data:
		completed[x][ACHV_COMPLETE] = false
	SignalBus.emit_signal("refresh_achievements_viewer")
	save_achievements()


func debug_reset_test_achv(achievement: String) -> void:
	completed[achievement][ACHV_COMPLETE] = false
	completed[achievement][ACHV_DATE] = "n/a"
	SignalBus.emit_signal("refresh_achievements_viewer")
	save_achievements()
