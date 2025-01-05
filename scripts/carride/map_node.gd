extends Node2D

var root_node: Node
var speed: float
var stop_processing: bool
var time_scale: float

func _ready() -> void:
	root_node = get_parent()
	speed = root_node.speed
	stop_processing = root_node.stop_processing
	time_scale = root_node.time_scale

func _process(_delta: float) -> void:
	speed = root_node.speed
	time_scale = root_node.time_scale
