extends Area2D

@export var speed = 500

signal reset_position(body)

var move_vector: Vector2
var y_limit = 60
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += move_vector * delta
	if move_vector.y > 0:
		if position.y >= y_limit:
			move_vector = Vector2(0,0)
	elif move_vector.y < 0:
		if position.y <= y_limit:
			move_vector = Vector2(0,0)


func _input(event):
	if event.is_action_pressed("move_up"):
		_move(true)
	elif event.is_action_pressed("move_down"):
		_move(false)
	elif event is InputEventScreenTouch:
		if event.pressed and event.index == 0:
			if event.position.y > (get_viewport().get_visible_rect().size.y / 2):
				_move(false)
			else:
				_move(true)


func _on_area_entered(area):
	if area.is_in_group("Milk"):
		reset_position.emit(null)
		owner.milks += 1
		$MilkPlayer.play()
	elif area.is_in_group("Obstacles"):
		$CrashPlayer.play()
		if not SettingsBus.godmode:
			visible = false
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://scenes/carride.tscn")


func _move(dir_up: bool):
	move_vector = Vector2(0, (-speed if dir_up else speed))
	y_limit += -80 if dir_up else 80

