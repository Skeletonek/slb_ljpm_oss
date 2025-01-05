class_name AIVehicle

extends Area2D

const VARIANTS = ["blue", "green", "white", "yellow"]
var variant: String
var anim: AnimatedSprite2D

var speed_diff = 0:
	get:
		return speed_diff


func _ready():
	SignalBus.reduce_motion.connect(_reduce_motion)
	anim = get_node_or_null("AnimatedSprite2D")
	if anim != null:
		var rnd = randi_range(0,3)
		variant = VARIANTS[rnd]
		anim.play(variant)
		if SettingsBus.reduced_motion:
			$AnimatedSprite2D.stop()
	if is_in_group("Obstacles"):
		speed_diff = randi_range(-40, 40)
	else:
		speed_diff = 300


func _process(delta):
	position += Vector2(-(owner.speed + speed_diff), 0) * delta


func _on_body_entered(_body):
	queue_free()


func _on_area_entered(area):
	if area is AIVehicle:
		speed_diff = area.speed_diff


func _reduce_motion(yes):
	if anim != null:
		if yes:
			anim.stop()
		else:
			anim.play(variant)
