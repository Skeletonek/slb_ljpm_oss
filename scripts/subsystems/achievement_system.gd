extends Control

enum {
	ACHV_NAME,
	ACHV_DESC,
	ACHV_ICON,
	ACHV_HIDDEN
}

const ACHIEVEMENT_LIST = {
	"test": ["Testowe osiągnięcie", "To jest testowe osiągnięcie", preload("res://images/icons/android_main.png"), false],
	"test2": ["Testowe osiągnięcie 2", "To jest drugie testowe osiągnięcie bo jedno to było za mało", preload("res://images/icons/android_main.png"), false],
	"test3": ["Testowe osiągnięcie 3", "To jest trzecie testowe osiągnięcie bo tak", preload("res://images/icons/android_main.png"), false],
	"hidden": ["Testowe ukryte osiągnięcie", "To jest testowe osiągnięcie które jest ukryte", preload("res://images/icons/android_main.png"), true],
	"paradise_island": ["Ty śpiochu...", "Wczuj się w rytm muzyki swojego alarmu", preload("res://images/icons/android_main.png"), false],
	"fatty_breakfast": ["Miałeś pójść po pół paczki żelek!", "Zrób sobie potwornie niezdrowe śniadanie", preload("res://images/icons/android_main.png"), false]
}

enum {
	ACHV_COMPLETE,
	ACHV_DATE,
}

var achievement_completed: Dictionary
var achievement_recently_completed: Dictionary

@onready var AchievementPanel = $CanvasLayer/AchievementPanelContainer
@onready var AchievementPanel2 = $CanvasLayer/AchievementPanelContainer2
@onready var AchievementPanel3 = $CanvasLayer/AchievementPanelContainer3
# var achievements_delay_timer := Timer.new()

func _ready():
	achievement_completed = generate_achv_completed_array()
	achievement_recently_completed = generate_achv_recently_completed_array()
	if not load_achievements():
		save_achievements()


func load_achievements() -> bool:
	if not FileAccess.file_exists("user://achievements.dat"):
		return false
	else:
		var file = FileAccess.open("user://achievements.dat", FileAccess.READ)
		var data = file.get_var(true)
		file.close()
# Old JSON loading
#		var file = FileAccess.open("user://achievements.json", FileAccess.READ)
#		var json_data = file.get_line()
#		var json = JSON.new() # Helper
#		var parse_result = json.parse(json_data)
#		if not parse_result == OK:
#			print("JSON Parse Error: ", json.get_error_message(), " in ", json_data, " at line ", json.get_error_line())
#			return false
#		var data = json.get_data()

		for x in data:
			achievement_completed[x] = data[x]
		return true
	return false


func save_achievements():
	var file = FileAccess.open("user://achievements.dat", FileAccess.WRITE)
	file.store_var(achievement_completed, true)
	file.close()
# Old JSON saving
#	var file = FileAccess.open("user://achievements.json", FileAccess.WRITE)
#	var json = JSON.stringify(achievement_completed)
#	file.store_line(json)


func generate_achv_completed_array() -> Dictionary:
	var dict = {}
	var arr = [false, "n/a"]
	for x in ACHIEVEMENT_LIST:
		dict[x] = arr.duplicate()
	return dict


func generate_achv_recently_completed_array() -> Dictionary:
	var dict = {}
	for x in ACHIEVEMENT_LIST:
		dict[x] = false
	return dict


func call_achievement(chosen_achievement: String):
	if not achievement_completed[chosen_achievement][ACHV_COMPLETE]:
		achievement_completed[chosen_achievement][ACHV_COMPLETE] = true
		achievement_completed[chosen_achievement][ACHV_DATE] = Time.get_datetime_string_from_system(false, true)
		achievement_recently_completed[chosen_achievement] = true
		save_achievements()
		print("EARNED ACHIEVEMENT: {TITLE:",
		ACHIEVEMENT_LIST[chosen_achievement][ACHV_NAME],
		", DESCRIPTION:",
		ACHIEVEMENT_LIST[chosen_achievement][ACHV_DESC],
		"}")
		_play_achievement(chosen_achievement)
		SignalBus.emit_signal("refresh_achievements_viewer")
		return true


func _play_achievement(chosen_achievement: String):
	# achievements_delay_timer.stop()
	if AchievementPanel.animation_state == AchievementPanel.IDLE:
		AchievementPanel.show_achievement(
			ACHIEVEMENT_LIST[chosen_achievement]
			)
	elif AchievementPanel2.animation_state == AchievementPanel.IDLE:
		AchievementPanel2.show_achievement(
			ACHIEVEMENT_LIST[chosen_achievement]
			)
	elif AchievementPanel3.animation_state == AchievementPanel.IDLE:
		AchievementPanel3.show_achievement(
			ACHIEVEMENT_LIST[chosen_achievement]
			)
	else:
		await get_tree().create_timer(6).timeout
		_play_achievement(chosen_achievement)


func debug_reset_test_achv():
	for x in ACHIEVEMENT_LIST:
		achievement_completed[x][ACHV_COMPLETE] = false
	SignalBus.emit_signal("refresh_achievements_viewer")
	save_achievements()
