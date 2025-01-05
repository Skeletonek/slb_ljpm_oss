extends CanvasLayer


@export var milk: Label
@export var milk_single_run: Label
@export var time_played_single_run: Label
@export var time_played_sum: Label
@export var top_speed: Label
@export var avg_speed: Label
@export var meters_driven: Label


func _ready() -> void:
	var p = ProfileBus.profile
	milk.text = str(p.milks_total)
	milk_single_run.text = str(p.milks_single_run)
	time_played_single_run.text = _time_to_friendly_string(p.time_played_single_run)
	time_played_sum.text = _time_to_friendly_string(p.time_played_sum)
	if p.top_speed != 0:
		top_speed.text = ("%.1f km/h" % ((p.top_speed + 300.0) / 10.0))
	avg_speed.text = str(p.avg_speed)
	meters_driven.text = str(p.meters_driven)


func _on_back_button_pressed():
	# gdlint:ignore=private-method-call
	$"../"._on_back_button_pressed()


@warning_ignore("integer_division")
func _time_to_friendly_string(time: int) -> String:
	var miliseconds: int = (time / 1000) % 1000
	var seconds: int = (time / 1000000) % 60
	var minutes: int = (time / 1000000) / 60
	return ("%02d:%02d:%03d" % [minutes, seconds, miliseconds])
