class_name PowerupClass extends Node2D

enum Powerups {
	RAM,
	SLOWMOTION,
	SEMAGLUTIDE,
	MILKYWAY
}

@export var type: Powerups
@export var time: float


func picked_up(player) -> void:
	$Area2D.call_deferred("set_process_mode", PROCESS_MODE_DISABLED)
	call_deferred("reparent", player)
	$VehicleComponent.process_mode = Node.PROCESS_MODE_DISABLED
	global_position = player.global_position
	z_index += 2
	await get_tree().create_timer(time, true, false, true).timeout
	queue_free()
