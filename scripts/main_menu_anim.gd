extends Camera2D

@export var animation_speed: int = 800
@export var speed := 200
@export var map: Node2D

var time_scale := 1.0
var stop_processing := false

@onready var luk_sprite: AnimatedSprite2D = $LukaszczykWPandzie/Sprite2D
@onready var luk_button: TouchScreenButton = $LukaszczykWPandzie/TouchScreenButton
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var milk_rain: CPUParticles2D = $MilkRain
@onready var confetti_rain: CPUParticles2D = $ConfettiRain


func _enter_tree() -> void:
	$ForestMap.hide()


func _ready():
	_scale_graphics()
	luk_sprite.play("default")
	anim_player.play("main_menu_sway")
	_set_skin()
	_set_map()
	SignalBus.cr_skin.connect(_set_skin)
	SignalBus.cr_map.connect(_set_map)
	_easter_egg()


func _process(_delta):
	_scale_graphics()


func _scale_graphics() -> void:
	var z = 1 / get_tree().root.get_content_scale_factor()
	zoom = Vector2(z, z)


func _set_skin():
	var skin_data = ProfileBus.get_skin_data(ProfileBus.profile.chosen_skin)
	luk_sprite.sprite_frames = skin_data['spriteframe']
	luk_sprite.scale = Vector2(skin_data['scale'], skin_data['scale'])
	luk_sprite.offset = Vector2(0, skin_data['y_pos_offset'])
	luk_sprite.play()


func _set_map():
	map.queue_free()
	var data = ProfileBus.get_map_data(ProfileBus.profile.chosen_map)
	map = data['scene'].instantiate()
	map.position.y = 150
	add_child(map)


func _easter_egg() -> void:
	var current_date = Time.get_date_dict_from_system()
	var birthday_days = [24, 25, 26]
	if current_date['month'] == Time.MONTH_JUNE and current_date['day'] == 1:
		milk_rain.emitting = true
		milk_rain.show()
	elif current_date['month'] == Time.MONTH_NOVEMBER and current_date['day'] in birthday_days:
		confetti_rain.emitting = true
		confetti_rain.show()
