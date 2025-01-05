extends AudioStreamPlayer

enum BtnType {
	STANDARD,
	SWITCH,
}

var musicfiles = [
	preload("res://audio/music/bloo-stricken_commision.ogg"),
	preload("res://audio/music/phonky.ogg"),
	preload("res://audio/music/digitist.ogg"),
	preload("res://audio/music/tech-junkie.ogg"),
	preload("res://audio/music/dead-ahead.ogg"),
	preload("res://audio/music/hard-trouble.ogg"),
	preload("res://audio/music/sahara.ogg"),
]

var soundeffects = [
	preload("res://audio/sfx/button.wav"),
	preload("res://audio/sfx/button_off.wav"),
	preload("res://audio/sfx/button_on.wav"),
]
var stricken_remastered = preload("res://audio/music/stricken_commision_remastered.ogg")
var random: int = 0


func connect_buttons(root):
	for child in root.get_children():
		if child is SwitchButton:
			child.toggled.connect(button_sound.bind(BtnType.SWITCH))
		elif child is BaseButton:
			child.pressed.connect(button_sound.bind(false,  BtnType.STANDARD))
		connect_buttons(child)


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


func button_sound(on: bool, type: BtnType) -> void:
	print("Pressed %s - %s" % [type, on])
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "SFX"
	player.finished.connect(func(): player.queue_free())
	match(type):
		BtnType.STANDARD:
			player.stream = soundeffects[0]
		BtnType.SWITCH:
			player.stream = soundeffects[2] if on else soundeffects[1]
	player.play()
