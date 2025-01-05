extends AudioStreamPlayer

var musicfiles = [
	preload("res://music/bloo-stricken_commision.ogg"),
	preload("res://music/Phonky.ogg"),
	preload("res://music/Digitist.ogg"),
	preload("res://music/tech-junkie.ogg")
]
# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(_on_global_music_finished)
	if not is_playing():
		_on_global_music_finished()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_global_music_finished():
	var random = randi_range(0,3)
	stream = musicfiles[random]
#	var date = int(Time.get_unix_time_from_system()) % 2
#	print("Unix Timestamp % 2 = ", date)
#	if date == 0:
#		stream = load("res://music/bloo-stricken_commision.ogg")
#	else:
#		stream = load("res://music/tech-junkie.ogg")
	play()
