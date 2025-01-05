extends Node2D

# signal vehicle_reached_oob

@export var map: Node2D
@export var version_2: bool
@export var speed_increment: float = 0.2

@export var speed: float = 0:
	get:
		return speed

@export var spawn_time_limit: float = 20:
	get:
		return spawn_time_limit

@export var spawn_time_milk_limit: float = 22:
	get:
		return spawn_time_milk_limit

var ai_vehicle_instance := preload("res://nodes/AIVehicle.tscn")
var milk_instance := preload("res://nodes/Milk.tscn")
var milk_triple_instance := preload("res://nodes/MilkTriple.tscn")
var powerup_slowmotion_instance := preload("res://nodes/Powerup_SlowMotion.tscn")

var stop_processing := false
var spawn_time: float = 0
var spawn_time_milk: float = 0
var spawn_milk_count: int = 1
var gauge_speed: float = -36

var milks: int = 0:
	get:
		return milks
	set(value):
		milks = value
		gui.update_points()

var time: int = 0:
	get:
		return time

var time_scale: float = 1.0:
	get:
		return time_scale
	set(x):
		time_scale = x

var final_score: int:
	get:
		return final_score

@onready var speedometer_gauge: Sprite2D = $Camera2D/Speedometer/SpeedometerGauge
@onready var gui: Control = $GUI
# @onready var milk_spawner: Timer = $Timer
@onready var bass_player: AudioStreamPlayer = $BassPlayer


func _enter_tree() -> void:
	$ForestMap.hide()


func _ready():
	_change_scale_factor()
	_set_map()
	# vehicle_reached_oob.connect(_respawn_vehicle)
	GlobalMusic.change_track()
	SignalBus.cr_map.connect(_set_map)


func _process(delta):
	_change_scale_factor() #FIXME: Find better solution
	_speed_management(delta)
	_achievement_check()
	bass_player.volume_db = clampf(-(80 - (speed * 0.10)), -80, 15)


func _physics_process(delta):
	_spawn_car(delta)
	_spawn_milk(delta)


func game_over():
	time_scale = 1.0
	final_score = (milks * 100000) + roundi((time) * 0.00001)
	bass_player.stop()
	$PauseLayer.process_mode = Node.PROCESS_MODE_DISABLED
	gui.game_over()
	stop_processing = true
	if not SettingsBus.cheats:
		_check_game_over_achievements()
		_add_scores()


func _speed_management(delta):
	if not stop_processing:
		time += delta * 1000000
		if speed < 1560:
			speed += delta * speed_increment * time_scale
			gauge_speed = (speed / 10) - 66
			speedometer_gauge.rotation_degrees = gauge_speed
	else:
		if speed > -300:
			speed -= delta * 250.0
		else:
			speed = -300


@warning_ignore("narrowing_conversion")
func _spawn_car(delta):
	if version_2:
		spawn_time += randf() * speed * 0.17 * delta * time_scale
	else:
		spawn_time += randi_range(0, (1 + ((speed - 300) / 300)))
	if spawn_time > spawn_time_limit:
		var loc_rnd = randi_range(0,4)
		var marker: Node2D = $SpawnPoints.get_child(loc_rnd)

		if marker.get_node("Area2D").has_overlapping_areas():
			return
		if loc_rnd - 1 > 0:
			var mrk_above: Node2D = $SpawnPoints.get_child(loc_rnd - 1)
			if mrk_above.get_node("Area2D").has_overlapping_areas():
				return
		if loc_rnd + 1 < 4:
			var mrk_below: Node2D = $SpawnPoints.get_child(loc_rnd + 1)
			if mrk_below.get_node("Area2D").has_overlapping_areas():
				return

		spawn_time = 0
		var car = ai_vehicle_instance.instantiate()
		car.position = marker.global_position
		add_child(car)
		car.owner = self


func _spawn_milk(delta):
	var milk
	spawn_time_milk += sqrt(speed) * delta * time_scale
	if spawn_time_milk > spawn_time_milk_limit:
		spawn_time_milk = 0
		if version_2:
			# milk_spawner.wait_time *= 1 / time_scale
			if spawn_milk_count >= 5:
				if randi_range(0,1) == 1:
					milk = milk_triple_instance.instantiate()
				else:
					milk = powerup_slowmotion_instance.instantiate()
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


func _add_scores():
	ProfileBus.profile.add_milks(milks)
	ProfileBus.profile.add_time(time)
	ProfileBus.profile.add_speed(speed)
	if not version_2:
		var leaderboard_name = "dev" if OS.is_debug_build() else "main"
		SilentWolf.Scores.save_score(
			SettingsBus.playername,
			final_score,
			leaderboard_name,
		)
	else:
		var metadata = {
			"milks": milks,
			"time": time,
			"speed": speed,
		}
		var leaderboard_name = "dev_2_0" if OS.is_debug_build() else "main_2_0"
		SilentWolf.Scores.save_score(
			SettingsBus.playername,
			final_score,
			leaderboard_name,
			metadata,
		)


func _set_map():
	map.queue_free()
	var data = ProfileBus.get_map_data(ProfileBus.profile.chosen_map)
	map = data['scene'].instantiate()
	map.position.y = 77
	add_child(map)


func _change_scale_factor():
	var zoom = 1 / get_tree().root.get_content_scale_factor()
	$Camera2D.zoom = Vector2(zoom, zoom)


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
