extends AudioStreamPlayer

var musicfiles = [
	preload("res://music/bloo-stricken_commision.ogg"),
	preload("res://music/phonky.ogg"),
	preload("res://music/digitist.ogg"),
	preload("res://music/tech-junkie.ogg"),
	preload("res://music/dead-ahead.ogg"),
	preload("res://music/hard-trouble.ogg")
]
var stricken_remastered = preload("res://music/stricken_commision_remastered.ogg")
var random: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_track():
	if random == 0:
		var rnd_remaster = randi_range(0,10)
		if rnd_remaster == 0:
			stream = stricken_remastered
			pass
	random = randi_range(0,5)
	stream = musicfiles[random]
	play()

