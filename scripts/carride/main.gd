extends Node2D

signal vehicle_reached_oob

@export var speed_increment: float = 0.2

@export var spawn_time_limit: int = 20:
	get:
		return spawn_time_limit
@export var speed: float = 0:
	get:
		return speed

@export var map: Node2D
@export var version_2: bool

var ai_vehicle_instance := preload("res://nodes/PandaAI.tscn")
var milk_instance := preload("res://nodes/Milk.tscn")
var milk_triple_instance := preload("res://nodes/MilkTriple.tscn")
var stop_processing := false
var spawn_time: int = 0
var spawn_milk_count: int = 1
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


func _enter_tree() -> void:
	$ForestMap.hide()


func _ready():
	_change_scale_factor()
	_set_map()
	vehicle_reached_oob.connect(_respawn_vehicle)
	GlobalMusic.change_track()
	SignalBus.cr_map.connect(_set_map)


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
			speed -= delta * 250.0
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
			car.position = marker.global_position
			add_child(car)
			car.owner = self


func game_over():
	final_score = (milks * 100000) + roundi((time) * 0.00001)
	gui.game_over()
	$PauseLayer.process_mode = Node.PROCESS_MODE_DISABLED
	stop_processing = true
	milk_spawner.stop()
	_check_game_over_achievements()
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
	var milk: Area2D
	if version_2:
		if spawn_milk_count >= 5:
			milk = milk_triple_instance.instantiate()
			spawn_milk_count = 0
		else:
			milk = milk_instance.instantiate()
		spawn_milk_count += 1
	else:
		milk = milk_instance.instantiate()
	var loc_rnd = randi_range(0,4)
	var marker: Node2D = $SpawnPoints.get_child(loc_rnd)
	milk.position = marker.position
	milk.position.x = marker.get_parent().position.x
	add_child(milk)
	milk.owner = self


func _respawn_vehicle(): # Is this needed anymore?
	var loc_rnd = randi_range(0,4)
	var marker: Node2D = $SpawnPoints.get_child(loc_rnd)
	$"PandaBlue".position = marker.position


func _set_map():
	map.queue_free()
	var data = ProfileBus.get_map_data(ProfileBus.profile.chosen_map)
	map = data['scene'].instantiate()
	map.position.y = 77
	add_child(map)


func _achievement_check():
	if speed > 800:
		AchievementSystem.call_achievement("speed_110")
	if speed > 1200:
		AchievementSystem.call_achievement("speed_150")
	if time > 60000000 and milks == 0:
		AchievementSystem.call_achievement("lactose_intolerant")


func _check_game_over_achievements():
	match(ProfileBus.profile.chosen_skin):
		Profile.Skins.VOLVO_COMBI:
			AchievementSystem.call_achievement("volvo_combi")
		Profile.Skins.REAL_PANDA:
			AchievementSystem.call_achievement("real_panda")
		Profile.Skins.PIGTANK:
			AchievementSystem.call_achievement("pigtank")
		# Profile.Skins.LUNAR_ROVER:
		# 	AchievementSystem.call_achievement("lunar_rover")
	match(ProfileBus.profile.chosen_map):
		Profile.Maps.SAHARA:
			AchievementSystem.call_achievement("sahara")
		Profile.Maps.LUNAR_CONFLICT:
			AchievementSystem.call_achievement("lunar_conflict")
