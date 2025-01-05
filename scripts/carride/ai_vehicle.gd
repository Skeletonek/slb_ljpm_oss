class_name AIVehicle

extends Node2D

const VARIANTS = ["blue", "green", "white", "yellow"]

@export var anim: AnimatedSprite2D

var variant: String


func _ready():
	SignalBus.reduce_motion.connect(_reduce_motion)
	var rnd = randi_range(0,3)
	variant = VARIANTS[rnd]
	anim.play(variant)
	if SettingsBus.reduced_motion:
		anim.stop()


func _reduce_motion(yes):
	if yes:
		anim.stop()
	else:
		anim.play(variant)
