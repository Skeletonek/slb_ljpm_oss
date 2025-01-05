class_name PickableComponent extends Node2D

@export var col_shape: CollisionShape2D
@export var pickup_sfx: AudioStream


func _on_area_2d_area_entered(area) -> void:
	if area.is_in_group("Player"):
		var player = area.get_node("PickupPlayer")
		player.stream = pickup_sfx
		player.play()
		owner.queue_free()
