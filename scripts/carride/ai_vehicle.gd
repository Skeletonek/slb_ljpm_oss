extends Area2D

@export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(-speed, 0) * delta


func _on_body_entered(body):
	var y = 350
	y += 100 * randi_range(0,2)
	position = Vector2(1450, y)
