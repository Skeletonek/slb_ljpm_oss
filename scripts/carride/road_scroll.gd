class_name SLB_ParallaxLayer extends Sprite2D

## Script for adding a parallax background to the scene with a static camera
##
## Each parallax layer should have this script connected
## [br]
## To achieve seamless transitions, one should create a sprite copy
## and add it as a parallax layer child

## Base game speed
const SPEED_INCREMENT := 300

## Jump point multiplier. 1 means the layer will "jump" after reaching
## the end of its main layer. Seting to 2, will wait a virtual one layer
## before jumping.
## This is most probably needed only for dynamic layers with animated sprites
@export var parallax_jump_point_scale := 1

## How strong the effect of parallax should be. Lower values mean slower
## scrolling, higher will scroll faster.
## 1.0 will move layer with the same speed as "camera"
@export var parallax_multiplier := 1.0

## If the layer should have some base speed added to the final calculation.
## Best used for animated sprites in the background that should still move when
## camera has stopped
@export var base_speed := 0

## If you turn on many things, they will execute in order
## from first variable to the last
@export_category("Motion reduction")

## If motion reduction should stop layer movement
@export var mr_stopped: bool

## If motion reduction should hide the layer
@export var mr_hidden: bool

## If motion reduction should change the parallax multiplier
## Use mr_stopped if you want to fully stop parallax effect
## instead of setting this value to 0
@export var mr_parallax_multiplier: float

## If motion reduction should load another texture
@export var mr_sprite: Texture2D

var _jump_point := 0.0
var _sprite := texture
var _stop := false
var _p_mul: float

func _ready():
	_jump_point = -(texture.get_size().x * scale.x * parallax_jump_point_scale)
	_p_mul = parallax_multiplier
	SignalBus.reduce_motion.connect(_reduce_motion)
	if mr_parallax_multiplier == 0.0:
		mr_parallax_multiplier = parallax_multiplier
	if SettingsBus.reduced_motion:
		_reduce_motion(true)


func _process(delta):
	if !_stop:
		if owner.stop_processing:
			if owner.speed <= -SPEED_INCREMENT:
				return
		position += Vector2(
				min(0 + base_speed,
					-(owner.speed + SPEED_INCREMENT + -base_speed)
						* owner.time_scale),
				0
		) * delta * _p_mul
		if position.x <= _jump_point:
			position.x = position.x + -_jump_point


func _reduce_motion(yes):
	match yes:
		true:
			_stop = mr_stopped
			if mr_hidden:
				hide()
			_p_mul = mr_parallax_multiplier
			if mr_sprite != null:
				texture = mr_sprite
				get_child(0).texture = mr_sprite
		false:
			_stop = false
			show()
			_p_mul = parallax_multiplier
			texture = _sprite
			get_child(0).texture = _sprite
