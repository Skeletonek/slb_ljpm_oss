extends Node2D

var stop_processing := false
var spawn_time: int = 0
var ai_vehicle_instance := preload("res://nodes/PandaAI.tscn")
var milk_instance := preload("res://nodes/Milk.tscn")

signal vehicle_reached_oob

@onready var GUI: Control = $GUI
@onready var MilkSpawner: Timer = $Timer

@export var speed_increment: float = 0.2

var spawn_time_limit: int = 20:
	get:
		return spawn_time_limit
#		return spawn_time_limit - floori(((speed - 300) / 66))

var spawn_rnd_min: int = 0:
	get:
		return spawn_rnd_min

var spawn_rnd_max: int = 1:
	get:
		return spawn_rnd_max + ((speed - 300) / 300)

@export var speed: float = 0:
	get:
		return speed
var milks: int = 0:
	get:
		return milks
	set(value):
		milks = value 
		GUI.update_points()


func game_over():
	GUI.game_over()
	$PauseLayer.process_mode = Node.PROCESS_MODE_DISABLED
	stop_processing = true


func _ready():
	_change_scale_factor()
	vehicle_reached_oob.connect(_respawn_vehicle)
	GlobalMusic.change_track()


func _process(delta):
	_change_scale_factor() #FIXME: Find better solution
	if not stop_processing:
		speed += pow(delta, 2) * speed_increment
	elif speed > -300:
		speed -= pow(delta, 2) * 10000


func _physics_process(delta):
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
	var y = 350
	y += 100 * randi_range(0,2)
	$"PandaBlue".position = Vector2(1450, y)
