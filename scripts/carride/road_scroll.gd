extends Sprite2D

const SPEED_INCREMENT := 300
@export var jump_point := -1440
@export var parallax_multiplier := 1.0

## For motion reducton settings
## if you turn on many things, they will execute in order
## from first variable to the last
@export_category("Motion reduction")
@export var mr_stopped: bool
@export var mr_hidden: bool
## Use mr_stopped if you want to fully stop parallax effect
## instead of setting this value to 0
@export var mr_parallax_multiplier: float
@export var mr_sprite: Texture2D

var _sprite := texture
var _stop := false
var _p_mul: float

func _ready():
	_p_mul = parallax_multiplier
	SignalBus.reduce_motion.connect(_reduce_motion)
	if mr_parallax_multiplier == 0.0:
		mr_parallax_multiplier = parallax_multiplier
	if SettingsBus.reduced_motion:
		_reduce_motion(true)


func _process(delta):
	if !_stop:
		if owner.stop_processing:
			if owner.speed <= -300:
				return
		position += Vector2(
				min(0,-(owner.speed + SPEED_INCREMENT) * owner.time_scale),
				0
		) * delta * _p_mul
		if position.x <= jump_point:
			position.x = position.x + -jump_point


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
