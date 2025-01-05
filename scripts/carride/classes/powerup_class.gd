class_name PowerupClass extends Node2D

enum Powerups {
	RAM,
	SLOWMOTION,
	SEMAGLUTIDE,
	MILKYWAY
}

@export var type: Powerups
@export var time: float
