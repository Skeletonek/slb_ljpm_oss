class_name AIVehicle

extends Node2D

const VARIANTS = ["blue", "green", "white", "yellow"]
const LC_VARIANTS = ["lc_rover", "lc_tank"]

var variant: String

@onready var car_animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var milk_sprite: Sprite2D = $Sprite2D
@onready var area2d: Area2D = $Area2D
@onready var car_collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var milk_collision_shape: CollisionShape2D = $Area2D/CollisionShape2DMilk
@onready var pickable_component: PickableComponent = $PickableComponent


func _ready():
	SignalBus.reduce_motion.connect(_reduce_motion)
	var rnd = 0
	if ProfileBus.profile.chosen_map == Profile.Maps.LUNAR_CONFLICT:
		rnd = randi_range(0, LC_VARIANTS.size()-1)
		variant = LC_VARIANTS[rnd]
		if variant == "lc_rover":
			car_animated_sprite.scale -= Vector2(0.06, 0.06)
	else:
		rnd = randi_range(0,VARIANTS.size()-1)
		variant = VARIANTS[rnd]
	car_animated_sprite.play(variant)
	if SettingsBus.reduced_motion:
		car_animated_sprite.stop()

	get_parent().powerup_milkyway.connect(powerup_milkyway_handler)
	if get_parent().powerup == PowerupClass.Powerups.MILKYWAY:
		_change_to_milk()


func _reduce_motion(yes):
	if yes:
		car_animated_sprite.stop()
	else:
		car_animated_sprite.play(variant)


func powerup_milkyway_handler(yes: bool) -> void:
	if yes:
		_change_to_milk()
	else:
		_change_from_milk()


func _change_to_milk() -> void:
	if is_in_group("Obstacles"):
		add_to_group("Milk")
		remove_from_group("Obstacles")
		car_animated_sprite.modulate.a = 0.1
		milk_sprite.show()
		car_collision_shape.set_deferred("disabled", true)
		milk_collision_shape.set_deferred("disabled", false)
		pickable_component.call_deferred("set_process", Node.PROCESS_MODE_INHERIT)
		area2d.area_entered.connect(
			pickable_component._on_area_2d_area_entered
		)


func _change_from_milk() -> void:
	if is_in_group("Milk"):
		add_to_group("Obstacles")
		remove_from_group("Milk")
		car_animated_sprite.modulate.a = 1.0
		milk_sprite.hide()
		car_collision_shape.set_deferred("disabled", false)
		milk_collision_shape.set_deferred("disabled", true)
		pickable_component.call_deferred("set_process", Node.PROCESS_MODE_DISABLED)
		area2d.area_entered.disconnect(
			pickable_component._on_area_2d_area_entered
		)

