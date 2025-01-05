extends Camera2D

@export var animation_speed: int = 800

@export var speed := 200
var stop_processing := false

@onready var panda_node: AnimatedSprite2D = $LukaszczykWPandzie
@onready var button: TouchScreenButton = $LukaszczykWPandzie/TouchScreenButton


func _ready():
	panda_node.play("default")
	var anim_player = panda_node.get_child(0) as AnimationPlayer
	anim_player.play("main_menu_sway")
	_set_skin()
	_set_map()
	SignalBus.cr_skin.connect(_set_skin)
	SignalBus.cr_map.connect(_set_map)


func _process(_delta):
	var z = 1 / get_tree().root.get_content_scale_factor()
	zoom = Vector2(z, z)


func _set_skin():
	var skin
	match(ProfileBus.profile.chosen_skin):
		Profile.Skins.FIAT_PANDA:
			skin = load("res://sprites/spriteframes/Panda.tres")
		Profile.Skins.PIGTANK:
			skin = load("res://sprites/spriteframes/Pigtank.tres")
	$LukaszczykWPandzie.sprite_frames = skin
	$LukaszczykWPandzie.play()


func _set_map():
	$ForestMap.hide()
	$SaharaMap.hide()
	$LunarConflictMap.hide()
	match(ProfileBus.profile.chosen_map):
		Profile.Maps.FOREST:
			$ForestMap.show()
		Profile.Maps.SAHARA:
			$SaharaMap.show()
		Profile.Maps.LUNAR_CONFLICT:
			$LunarConflictMap.show()
