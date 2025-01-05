extends Node2D

signal vehicle_reached_oob

@export var speed_increment: float = 0.2

@export var spawn_time_limit: int = 20:
	get:
		return spawn_time_limit
@export var speed: float = 0:
	get:
		return speed

var ai_vehicle_instance := preload("res://nodes/PandaAI.tscn")
var milk_instance := preload("res://nodes/Milk.tscn")
var stop_processing := false
var spawn_time: int = 0
var gauge_speed: float = -36

var milks: int = 0:
	get:
		return milks
	set(value):
		milks = value
		gui.update_points()

var spawn_rnd_min: int = 0:
	get:
		return spawn_rnd_min

var spawn_rnd_max: int = 1:
	get:
		return spawn_rnd_max + ((speed - 300) / 300)

var time: int = 0:
	get:
		return time

var final_score: int:
	get:
		return final_score

@onready var speedometer_gauge: Sprite2D = $Camera2D/Speedometer/SpeedometerGauge
@onready var gui: Control = $GUI
@onready var milk_spawner: Timer = $Timer


func _ready():
	_change_scale_factor()
	vehicle_reached_oob.connect(_respawn_vehicle)
	GlobalMusic.change_track()


func _process(delta):
	_change_scale_factor() #FIXME: Find better solution
	if not stop_processing:
		time += delta * 1000000
		if speed < 1560:
			speed += delta * speed_increment
			gauge_speed = (speed / 10) - 66
			speedometer_gauge.rotation_degrees = gauge_speed
	else:
		if speed > -300:
			speed -= pow(delta, 2) * 10000
		else:
			speed = -300
	_achievement_check()


func _physics_process(_delta):
	spawn_time += randi_range(spawn_rnd_min,spawn_rnd_max)
	if spawn_time > spawn_time_limit:
		var loc_rnd = randi_range(0,4)
		var marker: Node2D = $SpawnPoints.get_child(loc_rnd)
		if not (marker.get_node("Area2D") as Area2D).has_overlapping_areas():
			spawn_time = 0
			var car: Area2D = ai_vehicle_instance.instantiate()
			car.position = marker.position
			car.position.x = marker.get_parent().position.x
			add_child(car)
			car.owner = self


func game_over():
	final_score = (milks * 100000) + roundi((time) * 0.01)
	gui.game_over()
	$PauseLayer.process_mode = Node.PROCESS_MODE_DISABLED
	stop_processing = true
	milk_spawner.stop()
	if not SettingsBus.cheats:
		ProfileBus.profile.add_milks(milks)
		ProfileBus.profile.add_time(time)
		ProfileBus.profile.add_speed(speed)
		var leaderboard_name = "dev" if OS.is_debug_build() else "main"
		SilentWolf.Scores.save_score(SettingsBus.playername, final_score, leaderboard_name)


func _change_scale_factor():
	var zoom = 1 / get_tree().root.get_content_scale_factor()
	$Camera2D.zoom = Vector2(zoom, zoom)


func _spawn_milk():
	var loc_rnd = randi_range(0,4)
	var marker: Node2D = $SpawnPoints.get_child(loc_rnd)
	var milk: Area2D = milk_instance.instantiate()
	milk.position = marker.position
	milk.position.x = marker.get_parent().position.x
	add_child(milk)
	milk.owner = self


func _respawn_vehicle(): # Is this needed anymore?
	var loc_rnd = randi_range(0,4)
	var marker: Node2D = $SpawnPoints.get_child(loc_rnd)
	$"PandaBlue".position = marker.position


func _achievement_check():
	if speed > 800:
		AchievementSystem.call_achievement("speed_110")
	if speed > 1200:
		AchievementSystem.call_achievement("speed_150")
	if time > 60000000 and milks == 0:
		AchievementSystem.call_achievement("lactose_intolerant")
