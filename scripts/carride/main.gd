extends Node2D

@onready var GUI: Control = $GUI

signal vehicle_reached_oob

@export var speed_increment: float = 0.2

@export var speed: float = 0:
	get:
		return speed
var milks: int = 0:
	get:
		return milks
	set(value):
		milks = value 
		GUI.update_points()


func _ready():
	vehicle_reached_oob.connect(_respawn_vehicle)


func _process(delta):
	_change_scale_factor() #FIXME: Find better solution
	speed += pow(delta, 2) * speed_increment


func _change_scale_factor():
	var zoom = 1 / get_tree().root.get_content_scale_factor()
	$Camera2D.zoom = Vector2(zoom, zoom)


func _respawn_vehicle():
	var y = 350
	y += 100 * randi_range(0,2)
	$"PandaBlue".position = Vector2(1450, y)
