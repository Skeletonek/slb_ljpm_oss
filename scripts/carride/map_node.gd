extends Node2D

@export var root_node: Node

var speed: float
var stop_processing: bool

func _ready() -> void:
	speed = root_node.speed
	stop_processing = root_node.stop_processing

func _process(_delta: float) -> void:
	speed = root_node.speed
