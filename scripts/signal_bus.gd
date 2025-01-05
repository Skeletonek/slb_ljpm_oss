extends Node

# ONLY FOR SLB2. THESE SHOULD BE UNUSED HERE!
signal finished_loading
signal load_specific_timeline(timeline_path)
signal refresh_achievements_viewer

signal reduce_motion(yes: bool)
signal enable_touchscreen_vbuttons(yes: bool)
signal dev_console(yes: bool)

var dialogic_path

func _ready():
	finished_loading.connect(_on_finished_loading)


func _on_finished_loading():
	if not dialogic_path == null:
		SignalBus.emit_signal("load_specific_timeline", dialogic_path)
		dialogic_path = null
