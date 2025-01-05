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
	preload("res://audio/music/bloo-good_luck.ogg"),
]

var soundeffects = [
	preload("res://audio/sfx/button.wav"),
	preload("res://audio/sfx/button1.wav"),
	preload("res://audio/sfx/button_off.wav"),
	preload("res://audio/sfx/button_on.wav"),
]

var stricken_remastered = preload("res://audio/music/stricken_commision_remastered.ogg")
var random: int = 0
var spooky_easter_egg := false


func _enter_tree() -> void:
	var current_date = Time.get_date_dict_from_system()
	if current_date['month'] == Time.MONTH_OCTOBER and current_date['day'] == 31:
		spooky_easter_egg = true
		stream = load("res://audio/music/spooky-scary-skeletons.ogg")
		play()


func connect_buttons(root):
	for child in root.get_children():
		if child is BaseButton and child.toggle_mode == true:
			child.toggled.connect(button_sound.bind(BtnType.SWITCH))
		elif child is BaseButton:
			child.pressed.connect(button_sound.bind(false,  BtnType.STANDARD))
		connect_buttons(child)


func change_track():
	if not spooky_easter_egg:
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
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "SFX"
	player.finished.connect(func(): player.queue_free())
	match(type):
		BtnType.STANDARD:
			player.stream = soundeffects[0] if \
				int(Time.get_unix_time_from_system()) % 2 == 0 else \
				soundeffects[1]
		BtnType.SWITCH:
			player.stream = soundeffects[3] if on else soundeffects[2]
	print(player.stream)
	player.play()
