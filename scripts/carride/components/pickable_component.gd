class_name PickableComponent extends Node2D

@export var col_shape: CollisionShape2D
@export var pickup_sfx: AudioStream


# DEPRECATED: Is not used after collsion refactor in 2.1.0
func _on_area_2d_area_entered(_area) -> void:
	pass
	# if area.is_in_group("Player"):
		# var player = area.get_node("PickupPlayer")
		# player.stream = pickup_sfx
		# player.play()
		# owner.queue_free()
