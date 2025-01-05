class_name VehicleComponent extends Node2D

var speed_diff = 0:
	get:
		return speed_diff

var raycast


func _ready() -> void:
	if owner.is_in_group("Car"):
		speed_diff = randi_range(-20, 20)
		raycast = get_parent().get_node("RayCast2D")
	else:
		speed_diff = 300


func _process(delta: float) -> void:
	owner.position += (
		Vector2(-(owner.owner.speed + speed_diff), 0) *
		delta *
		owner.owner.time_scale
	)


func _on_area_2d_area_entered(area):
	var ar = area.get_parent()
	if owner.is_in_group("Car") and ar.is_in_group("Car"):
		if ar.has_node("VehicleComponent") and raycast:
			raycast.force_raycast_update()
			if raycast.get_collider() == area:
				speed_diff = ar.get_node("VehicleComponent").speed_diff
	if ar.is_in_group("OutOfBounds"):
		owner.queue_free()
