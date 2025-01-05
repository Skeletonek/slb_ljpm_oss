extends CanvasLayer


@export var games: Label
@export var runs: Label
@export var milk: Label
@export var milk_single_run: Label
@export var time_played_single_run: Label
@export var time_played_sum: Label
@export var top_speed: Label
@export var top_speed_avg: Label
@export var distance_sum: Label
@export var distance_single_run: Label
@export var powerups_ram: Label
@export var powerups_slowmotion: Label
@export var powerups_semaglutide: Label
@export var powerups_milkyway: Label


func _ready() -> void:
	var p = ProfileBus.profile
	games.text = str(p.games)
	runs.text = str(p.runs)
	milk.text = str(p.milks_total)
	milk_single_run.text = str(p.milks_single_run)
	time_played_single_run.text = _time_to_friendly_string(p.time_played_single_run, false)
	time_played_sum.text = _time_to_friendly_string(p.time_played_sum, true)
	if p.top_speed != 0:
		top_speed.text = ("%.1f km/h" % ((((p.top_speed / 10 ) - 66) / 0.9 ) + 100))
		top_speed_avg.text = ("%.1f km/h" % ((((p.top_speed_avg / 10 ) - 66) / 0.9 ) + 100))
	distance_sum.text = ("%.2f km" % (p.distance_sum / 33500))
	distance_single_run.text = ("%.2f km" % (p.distance_single_run / 33500))
	powerups_ram.text = str(p.powerups_ram)
	powerups_slowmotion.text = str(p.powerups_slowmotion)
	powerups_semaglutide.text = str(p.powerups_semaglutide)
	powerups_milkyway.text = str(p.powerups_milkyway)


func _on_back_button_pressed():
	# gdlint:ignore=private-method-call
	$"../"._on_back_button_pressed()


@warning_ignore("integer_division")
func _time_to_friendly_string(time: int, show_hours: bool) -> String:
	var miliseconds: int = (time / 1000) % 1000
	var seconds: int = (time / 1000000) % 60
	var minutes: int = (time / 1000000) / 60
	if show_hours:
		var hours: int = (time / 1000000) / 3600
		return ("%02d:%02d:%02d:%03d" % [hours, minutes, seconds, miliseconds])
	return ("%02d:%02d:%03d" % [minutes, seconds, miliseconds])
