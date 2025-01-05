extends Control

signal touchscreen_move(direction: bool)

@export var LabelTime: Label
@export var LabelMilk: Label
@onready var Speedometer: Label = $HBoxContainer3/LabelSpeed
var start_time: int
var diff_time: int

const MINIMUM_SWIPE_DRAG = 60
var swipe_start: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = Time.get_ticks_msec()
	diff_time = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	diff_time = Time.get_ticks_msec() - start_time
	var miliseconds: int = diff_time % 1000
	var seconds: int = (diff_time / 1000) % 60
	var minutes: int = (diff_time / 1000) / 60
	LabelTime.text = ("%02d:%02d:%03d" % [minutes, seconds, miliseconds])
	Speedometer.text = ("%.3f" % [owner.speed])

func update_points():
	LabelMilk.text = str(owner.milks)


func _gui_input(event):
	if event is InputEventScreenTouch:
		if SettingsBus.touchscreen_control == SettingsBus.TOUCHSCREEN_CONTROL_MODE.Tap:
			if event.pressed and event.index == 0:
				if event.position.y > (get_viewport().get_visible_rect().size.y / 2):
					touchscreen_move.emit(false)
				else:
					touchscreen_move.emit(true)
		elif SettingsBus.touchscreen_control == SettingsBus.TOUCHSCREEN_CONTROL_MODE.Swipe:
			if event.pressed and event.index == 0:
				swipe_start = event.get_position()
			elif event.index == 0:
				_calculate_swipe(event.get_position())


func _calculate_swipe(swipe_end: Vector2):
	if swipe_start == null:
		return
	var swipe = swipe_end - swipe_start
	if abs(swipe.y) > MINIMUM_SWIPE_DRAG:
		if swipe.y > 0:
			touchscreen_move.emit(false)
		else:
			touchscreen_move.emit(true)
