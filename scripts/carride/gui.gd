extends Control

signal touchscreen_move(direction: bool)

const MINIMUM_SWIPE_DRAG = 60

@export var label_time: Label
@export var label_milk: Label

var diff_time: int
var swipe_start: Vector2
var stop_processing := false

@onready var speedometer: Label = $HBoxContainer3/LabelSpeed
@onready var game_over_panel := $PanelContainer
@onready var score_label := $PanelContainer/MarginContainer/VBoxContainer/ScoreLabel
@onready var play_again_button := $PanelContainer/MarginContainer/VBoxContainer/PlayAgainBtn


func _ready():
	if SettingsBus.easier_font:
		label_time.label_settings.font_size = 32
	diff_time = 0
	SignalBus.enable_touchscreen_vbuttons.connect(_enable_vbuttons)
	if SettingsBus.touchscreen_control == SettingsBus.TouchscreenControlMode.VBUTTONS:
		_enable_vbuttons(true)


func _process(_delta):
	if not stop_processing:
		diff_time = owner.time
		var miliseconds: int = diff_time % 1000
		var seconds: int = (diff_time / 1000) % 60
		var minutes: int = (diff_time / 1000) / 60
		label_time.text = ("%02d:%02d:%03d" % [minutes, seconds, miliseconds])
		speedometer.text = ("%.3f" % [owner.speed])


func update_points():
	label_milk.text = str(owner.milks)


func game_over():
	stop_processing = true
	score_label.text = str(owner.final_score)
	play_again_button.grab_focus()
	game_over_panel.show()


func _gui_input(event):
	if event is InputEventScreenTouch:
		if SettingsBus.touchscreen_control == SettingsBus.TouchscreenControlMode.TAP:
			if event.pressed and event.index == 0:
				if event.position.y > (get_viewport().get_visible_rect().size.y / 2):
					touchscreen_move.emit(false)
				else:
					touchscreen_move.emit(true)
		elif SettingsBus.touchscreen_control == SettingsBus.TouchscreenControlMode.SWIPE:
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


func _enable_vbuttons(yes: bool):
	if yes:
		$VButtonsContainer.show()
	else:
		$VButtonsContainer.hide()


func _on_play_again_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/carride.tscn")


func _on_menu_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")


func _on_up_button_down():
	touchscreen_move.emit(true)


func _on_down_button_down():
	touchscreen_move.emit(false)
