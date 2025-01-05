# 33500 units is a ~1 kilometer

extends Node2D

signal powerup_milkyway(yes: bool)
signal powerup_semaglutide(yes: bool)

@export var map: Node2D
@export var player: Area2D
@export var version_2: bool
@export var speed_increment: float = 0.2

@export var speed: float = 0:
	get:
		return speed
	set(x):
		speed = x
		real_speed = (((speed / 10 ) - 66) / 0.9 ) + 100

@export var real_speed: float = 0:
	get:
		return real_speed

@export var spawn_time_limit: float = 16:
	get:
		return spawn_time_limit

@export var spawn_time_milk_limit: float = 22:
	get:
		return spawn_time_milk_limit

var ai_vehicle_instance := preload("res://nodes/AIVehicle.tscn")
var milk_instance := preload("res://nodes/Milk.tscn")
var milk_triple_instance := preload("res://nodes/MilkTriple.tscn")
var powerup_slowmotion_instance := preload("res://nodes/Powerup_SlowMotion.tscn")
var powerup_milkyway_instance := preload("res://nodes/Powerup_Milkyway.tscn")
var powerup_semaglutide_instance := preload("res://nodes/Powerup_Semaglutide.tscn")

var previous_milk_spawn: int = -1
var original_speed: float
var stop_processing := false
var spawn_time: float = 0
var spawn_time_milk: float = 0
var spawn_milk_count: int = 1
var powerup_timer: Timer
var powerup_counter = Dictionary()

var lives: int = 1:
	get:
		return lives
	set(value):
		lives = value

var milks: int = 0:
	get:
		return milks
	set(value):
		milks = value
		gui.update_points()

var powerup:
	get:
		return powerup
	set(value):
		reset_powerup()
		powerup = value
		if value != null:
			powerup = value.type
			start_powerup(value)
			powerup_counter[value.type] += 1

var time: int = 0:
	get:
		return time

var distance: float = 0.0:
	get:
		return distance

var time_scale: float = 1.0:
	get:
		return time_scale
	set(value):
		time_scale = value

var final_score: int:
	get:
		return final_score

@onready var gui: Control = $GUI
# @onready var milk_spawner: Timer = $Timer
@onready var bass_player: AudioStreamPlayer = $BassPlayer


func _enter_tree() -> void:
	$ForestMap.hide()


func _ready():
	_change_scale_factor()
	_set_map()
	SignalBus.reload_scale_factor.connect(_change_scale_factor)
	# vehicle_reached_oob.connect(_respawn_vehicle)
	GlobalMusic.change_track()
	SignalBus.cr_map.connect(_set_map)
	if version_2:
		lives = 3
		original_speed = speed
		powerup_timer = $PowerupTimer
		powerup_timer.timeout.connect(func(): powerup = null)
		for x in PowerupClass.Powerups.values():
			powerup_counter[x] = 0


func _process(delta):
	_change_scale_factor() #FIXME: Find better solution
	_speed_management(delta)
	_achievement_check()
	bass_player.volume_db = clampf(-(80 - (speed * 0.10)), -80, 15)
	distance += (speed + 300) * time_scale * delta


func _physics_process(delta):
	_spawn_car(delta)
	_spawn_milk(delta)


func game_over():
	final_score = (milks * 100000) + roundi((time) * 0.00001)
	bass_player.stop()
	$PauseLayer.process_mode = Node.PROCESS_MODE_DISABLED
	gui.game_over()
	stop_processing = true
	if not SettingsBus.cheats:
		_check_game_over_achievements()
		_add_scores()


func start_powerup(pwr_node):
	match(pwr_node.type):
		PowerupClass.Powerups.SLOWMOTION:
			time_scale = 0.5
		PowerupClass.Powerups.MILKYWAY:
			powerup_milkyway.emit(true)
		PowerupClass.Powerups.SEMAGLUTIDE:
			powerup_semaglutide.emit(true)
	powerup_timer.start(pwr_node.time)
	gui.show_powerup(pwr_node.type)
	gui.powerup_ending_timer.start(pwr_node.time - 3)


func reset_powerup():
	time_scale = 1.0
	powerup_milkyway.emit(false)
	powerup_semaglutide.emit(false)
	powerup_timer.stop()
	gui.hide_powerup()
	gui.powerup_ending_timer.stop()
	gui.stop_blinking_powerup()


func _speed_management(delta):
	if not stop_processing:
		time += delta * 1000000
		if speed < 1560:
			speed += delta * speed_increment * time_scale
			gui.gauge_speed = (speed / 10) - 66
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
				var rnd = randi_range(0,4)
				if rnd == previous_milk_spawn:
					rnd = (rnd + 1) % 5
				previous_milk_spawn = rnd
				match(rnd):
					0:
						milk = milk_triple_instance.instantiate()
					1:
						milk = milk_triple_instance.instantiate()
					2:
						milk = powerup_slowmotion_instance.instantiate()
					3:
						milk = powerup_milkyway_instance.instantiate()
					4:
						milk = powerup_semaglutide_instance.instantiate()
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
	ProfileBus.profile.add_game()
	ProfileBus.profile.add_run()
	ProfileBus.profile.add_milks(milks)
	ProfileBus.profile.add_time(time)
	ProfileBus.profile.add_speed(speed)
	ProfileBus.profile.add_distance(distance)
	if version_2:
		ProfileBus.profile.add_powerups(powerup_counter)
	if not version_2:
		var leaderboard_name = (
			"dev"
			if OS.is_debug_build() or OS.has_feature("private-test")
			else "main"
		)
		SilentWolf.Scores.save_score(
			ProfileBus.profile.get_full_playername(),
			final_score,
			leaderboard_name,
		)
	else:
		var metadata = {
			"distance": (distance / 33500) * 1000,
			"time": time,
		}
		var leaderboard_name = (
			"dev_2_0_milk"
			if OS.is_debug_build() or OS.has_feature("private-test")
			else "main_2_0_milk"
		)
		SilentWolf.Scores.save_score(
			ProfileBus.profile.get_full_playername(),
			milks,
			leaderboard_name,
			metadata,
		)
		metadata = {
			"milks": milks,
			"time": time,
		}
		leaderboard_name = (
			"dev_2_0_distance"
			if OS.is_debug_build() or OS.has_feature("private-test")
			else "main_2_0_distance"
		)
		SilentWolf.Scores.save_score(
			ProfileBus.profile.get_full_playername(),
			(distance / 33500) * 1000,
			leaderboard_name,
			metadata,
		)
	ProfileBus.save_profile_to_file()


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
	if real_speed > 110:
		AchievementSystem.call_achievement("speed_110")
	if real_speed > 150:
		AchievementSystem.call_achievement("speed_150")
	if real_speed > 200:
		AchievementSystem.call_achievement("speed_200")
	if not version_2 and time > 60000000 and milks == 0:
		AchievementSystem.call_achievement("lactose_intolerant")
	if version_2 and time > 180000000 and powerup_counter.values().all(
		func(x): return x == 0
	):
		AchievementSystem.call_achievement("no_powerups")
	if milks >= 200:
		AchievementSystem.call_achievement("milk_single_run")


func _check_game_over_achievements():
	var skin_name = Profile.Skins.keys()[ProfileBus.profile.chosen_skin].to_lower()
	if skin_name in AchievementSystem.data:
		AchievementSystem.call_achievement(skin_name)
	var map_name = Profile.Maps.keys()[ProfileBus.profile.chosen_map].to_lower()
	if map_name in AchievementSystem.data:
		AchievementSystem.call_achievement(map_name)
	var stats_milk = ProfileBus.profile.milks_total
	if stats_milk + milks >= 5000:
		AchievementSystem.call_achievement("milk_5000")
	if stats_milk + milks >= 2000:
		AchievementSystem.call_achievement("milk_2000")
	if stats_milk + milks >= 500:
		AchievementSystem.call_achievement("milk_500")
	var stats_distance = ProfileBus.profile.distance_sum
	if stats_distance + distance >= 335000:
		AchievementSystem.call_achievement("distance1")
	if stats_distance + distance >= 3350000:
		AchievementSystem.call_achievement("distance2")
	if stats_distance + distance >= 6700000:
		AchievementSystem.call_achievement("distance3")
