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

var data: Dictionary
var completed: Dictionary
var recently_completed: Dictionary

@onready var AchievementPanel = $CanvasLayer/AchievementPanelContainer
@onready var AchievementPanel2 = $CanvasLayer/AchievementPanelContainer2
@onready var AchievementPanel3 = $CanvasLayer/AchievementPanelContainer3
@onready var AchievementList = $AchvList
# var achievements_delay_timer := Timer.new()

func _ready():
	data = AchievementList.ACHIEVEMENT_LIST
	completed = generate_achv_completed_array()
	recently_completed = generate_achv_recently_completed_array()
	if not load_achievements():
		save_achievements()


func load_achievements() -> bool:
	if not FileAccess.file_exists("user://achievements.dat"):
		return false
	else:
		var file = FileAccess.open("user://achievements.dat", FileAccess.READ)
		var dat = file.get_var(true)
		file.close()
# Old JSON loading
#		var file = FileAccess.open("user://achievements.json", FileAccess.READ)
#		var json_data = file.get_line()
#		var json = JSON.new() # Helper
#		var parse_result = json.parse(json_data)
#		if not parse_result == OK:
#			print("JSON Parse Error: ", json.get_error_message(), " in ", json_data, " at line ", json.get_error_line())
#			return false
#		var dat = json.get_data()

		for x in dat:
			completed[x] = dat[x]
		return true


func save_achievements():
	var file = FileAccess.open("user://achievements.dat", FileAccess.WRITE)
	file.store_var(completed, true)
	file.close()
# Old JSON saving
#	var file = FileAccess.open("user://achievements.json", FileAccess.WRITE)
#	var json = JSON.stringify(achievement_completed)
#	file.store_line(json)


func generate_achv_completed_array() -> Dictionary:
	var dict = {}
	var arr = [false, "n/a"]
	for x in data:
		dict[x] = arr.duplicate()
	return dict


func generate_achv_recently_completed_array() -> Dictionary:
	var dict = {}
	for x in data:
		dict[x] = false
	return dict


func call_achievement(achievement: String):
	if not completed[achievement][ACHV_COMPLETE]:
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
	else:
		push_warning("Achievement has been already awarded!")
		return true


func _play_achievement(achievement: String):
	# achievements_delay_timer.stop()
	if AchievementPanel.animation_state == AchievementPanel.IDLE:
		AchievementPanel.show_achievement(
			data[achievement]
			)
	elif AchievementPanel2.animation_state == AchievementPanel.IDLE:
		AchievementPanel2.show_achievement(
			data[achievement]
			)
	elif AchievementPanel3.animation_state == AchievementPanel.IDLE:
		AchievementPanel3.show_achievement(
			data[achievement]
			)
	else:
		await get_tree().create_timer(6).timeout
		_play_achievement(achievement)


func debug_reset_test_achv():
	for x in data:
		completed[x][ACHV_COMPLETE] = false
	SignalBus.emit_signal("refresh_achievements_viewer")
	save_achievements()
