extends Node2D


signal vehicle_reached_oob
# Called when the node enters the scene tree for the first time.
func _ready():
	var date = int(Time.get_unix_time_from_system()) % 2
	if date == 0:
		GlobalMusic.stream = load("res://music/bloo-stricken_commision.ogg")
	else:
		GlobalMusic.stream = load("res://music/tech-junkie.ogg")
	GlobalMusic.play()
	vehicle_reached_oob.connect(_respawn_vehicle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_change_scale_factor()


func _change_scale_factor():
	var zoom = 1 / get_tree().root.get_content_scale_factor()
	$Camera2D.zoom = Vector2(zoom, zoom)


func _respawn_vehicle():
	var y = 350
	y += 100 * randi_range(0,2)
	$"PandaBlue".position = Vector2(1450, y)
