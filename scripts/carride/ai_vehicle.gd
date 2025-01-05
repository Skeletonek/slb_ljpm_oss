extends Area2D

@export var speed_increment = 0 #Probably obsolete value
func _ready():
	pass


func _process(delta):
	position += Vector2(-(owner.speed + speed_increment), 0) * delta


func _on_body_entered(body):
	reset_postion()


func reset_postion():
	var y = -100
	y += 80 * randi_range(0,4)
	position = Vector2(940, y)
