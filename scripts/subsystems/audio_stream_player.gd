extends AudioStreamPlayer

var musicfiles = [
	preload("res://audio/music/bloo-stricken_commision.ogg"),
	preload("res://audio/music/phonky.ogg"),
	preload("res://audio/music/digitist.ogg"),
	preload("res://audio/music/tech-junkie.ogg"),
	preload("res://audio/music/dead-ahead.ogg"),
	preload("res://audio/music/hard-trouble.ogg"),
	preload("res://audio/music/sahara.ogg"),
]
var stricken_remastered = preload("res://audio/music/stricken_commision_remastered.ogg")
var random: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func change_track():
	if random == 0:
		var rnd_remaster = randi_range(0,10)
		if rnd_remaster == 0:
			var pos = get_playback_position()
			stream = stricken_remastered
			play()
			seek(pos)
			return
	random = randi_range(0,len(musicfiles)-1)
	stream = musicfiles[random]
	play()

