extends Node

# ONLY FOR SLB2. THESE SHOULD BE UNUSED HERE!
signal finished_loading
signal load_specific_timeline(timeline_path)
signal refresh_achievements_viewer
signal reload_scale_factor

signal vsync_checked
signal enable_touchscreen_vbuttons(yes: bool)
signal switch_touchscreen_mode
signal dev_console(yes: bool)
signal enable_telemetry(yes: bool)
signal reduce_motion(yes: bool)

signal call_achievement(name)

signal cr_speedometer_value(yes: bool)
signal cr_skin
signal cr_map
signal cr_update_milks_count
signal cr_ch_unlock_maps
signal cr_ch_unlock_skins

var dialogic_path
var ch_unlock_maps = false
var ch_unlock_skins = false

func _ready():
	finished_loading.connect(_on_finished_loading)
	call_achievement.connect(on_call_achievement)


func _on_finished_loading():
	if not dialogic_path == null:
		SignalBus.emit_signal("load_specific_timeline", dialogic_path)
		dialogic_path = null


func on_call_achievement(title):
	AchievementSystem.call_achievement(title)
