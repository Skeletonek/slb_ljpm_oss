extends Sprite2D

@export var speed = 500
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(-speed,0) * delta
	if position.x <= 439:
		position.x = 639
