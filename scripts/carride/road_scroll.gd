extends Sprite2D

@export var speed_increment = 300 #Obsolete?
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(-(owner.speed + speed_increment),0) * delta
	if position.x <= -90:
		position.x = 70 - delta
