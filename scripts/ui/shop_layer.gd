extends CanvasLayer

@export var skin_image: TextureRect
@export var skin_name: Label
@export var skin_price: Label
@export var map_image: TextureRect
@export var map_name: Label
@export var map_price: Label
@export var milks: Label

var skin_index := 0
var map_index := 0

var all_skins: int
var all_maps: int


func _ready() -> void:
	skin_index = ProfileBus.profile.chosen_skin
	map_index = ProfileBus.profile.chosen_map
	all_skins = Profile.Skins.size()
	all_maps = Profile.Maps.size()
	_update_skin_panel()
	_update_map_panel()
	milks.text = str(ProfileBus.profile.milks)


func switch_skin(i_add: int) -> void: _switch(i_add, true)


func switch_map(i_add: int) -> void: _switch(i_add, false)


func _switch(i_add: int, is_skin: bool) -> void:
	var idx = skin_index if is_skin else map_index
	var all = all_skins if is_skin else all_maps
	idx += i_add
	if idx >= all:
		idx = 0
	elif idx < 0:
		idx = all - 1
	if is_skin:
		skin_index = idx
		_update_skin_panel()
		# Temporary code
		ProfileBus.profile.chosen_skin = skin_index as Profile.Skins
		SignalBus.cr_skin.emit()
	else:
		map_index = idx
		_update_map_panel()
		# Temporary code
		ProfileBus.profile.chosen_map = map_index as Profile.Maps
		SignalBus.cr_map.emit()


func _update_skin_panel() -> void:
	var data = ProfileBus.get_skin_data(skin_index)
	skin_image.texture = data['texture']
	skin_name.text = data['name']


func _update_map_panel() -> void:
	var data = ProfileBus.get_map_data(map_index)
	map_image.texture = data['texture']
	map_name.text = data['name']


func _on_back_button_pressed():
	# gdlint:ignore=private-method-call
	$"../"._on_back_button_pressed()
