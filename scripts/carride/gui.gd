extends Control

@export var LabelTime: Label
var start_time: int
var diff_time: int
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
