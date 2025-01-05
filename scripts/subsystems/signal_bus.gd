extends Node

# ONLY FOR SLB2. THESE SHOULD BE UNUSED HERE!
signal finished_loading
signal load_specific_timeline(timeline_path)
signal refresh_achievements_viewer

signal reduce_motion(yes: bool)
signal enable_touchscreen_vbuttons(yes: bool)
signal call_achievement(name)
signal dev_console(yes: bool)

var dialogic_path

func _ready():
	finished_loading.connect(_on_finished_loading)
	call_achievement.connect(on_call_achievement)


func _on_finished_loading():
	if not dialogic_path == null:
		SignalBus.emit_signal("load_specific_timeline", dialogic_path)
		dialogic_path = null


func on_call_achievement(title):
	AchievementSystem.call_achievement(title)
