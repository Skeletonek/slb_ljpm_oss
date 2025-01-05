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
	time_played_single_run.text = str(p.time_played_single_run)
	time_played_sum.text = str(p.time_played_sum)
	top_speed.text = str(p.top_speed)
	avg_speed.text = str(p.avg_speed)
	meters_driven.text = str(p.meters_driven)


func _on_back_button_pressed():
	# gdlint:ignore=private-method-call
	$"../"._on_back_button_pressed()
