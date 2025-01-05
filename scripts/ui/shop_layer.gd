extends CanvasLayer

@export_category("Skin")
@export var skin_image: TextureRect
@export var skin_name: Label
@export var skin_price: Label
@export var skin_buy_button: Button
@export var skin_lock_icon: TextureRect
@export var skin_community_icon: TextureRect

@export_category("Map")
@export var map_image: TextureRect
@export var map_name: Label
@export var map_price: Label
@export var map_buy_button: Button
@export var map_lock_icon: TextureRect
@export var map_community_icon: TextureRect

@export_category("Misc")
@export var milks: Label
@export var buy_success_player: AudioStreamPlayer
@export var buy_fail_player: AudioStreamPlayer

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
	SignalBus.cr_ch_unlock_skins.connect(_update_skin_panel)
	SignalBus.cr_ch_unlock_maps.connect(_update_map_panel)
	SignalBus.cr_update_milks_count.connect(_update_milks_count)
	_update_milks_count()


func switch(i_add: int, is_skin: bool) -> void:
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
		if ProfileBus.profile.change_skin(skin_index as Profile.Skins):
			SignalBus.cr_skin.emit()
	else:
		map_index = idx
		_update_map_panel()
		# Temporary code
		if ProfileBus.profile.change_map(map_index as Profile.Maps):
			SignalBus.cr_map.emit()


func buy_skin() -> void:
	var data = ProfileBus.get_skin_data(skin_index)
	if ProfileBus.profile.milks >= data['price']:
		ProfileBus.profile.skins[skin_index as Profile.Skins] = true
		ProfileBus.profile.milks -= data['price']
		skin_lock_icon.hide()
		skin_buy_button.text = "W posiadaniu"
		skin_buy_button.disabled = true
		ProfileBus.profile.change_skin(skin_index as Profile.Skins)
		SignalBus.cr_skin.emit()
		_update_milks_count()
		buy_success_player.play()
		_check_achievement()
	else:
		buy_fail_player.play()


func buy_map() -> void:
	var data = ProfileBus.get_map_data(map_index)
	if ProfileBus.profile.milks >= data['price']:
		ProfileBus.profile.maps[map_index as Profile.Maps] = true
		ProfileBus.profile.milks -= data['price']
		map_lock_icon.hide()
		map_buy_button.text = "W posiadaniu"
		map_buy_button.disabled = true
		ProfileBus.profile.change_map(map_index as Profile.Maps)
		SignalBus.cr_map.emit()
		_update_milks_count()
		buy_success_player.play()
		_check_achievement()
	else:
		buy_fail_player.play()


func _update_skin_panel() -> void:
	var data = ProfileBus.get_skin_data(skin_index)
	skin_image.texture = data['texture']
	skin_name.text = data['name']
	skin_community_icon.visible = data['community_made']
	skin_price.text = str(data['price'])
	if ProfileBus.profile.skins[skin_index]:
		skin_buy_button.text = "W posiadaniu"
		skin_buy_button.disabled = true
		skin_lock_icon.hide()
	else:
		skin_buy_button.text = "Kup"
		skin_buy_button.disabled = false
		skin_lock_icon.show()
	if SignalBus.ch_unlock_skins:
		skin_price.text = "The Price is Right"


func _update_map_panel() -> void:
	var data = ProfileBus.get_map_data(map_index)
	map_image.texture = data['texture']
	map_name.text = data['name']
	map_community_icon.visible = data['community_made']
	map_price.text = str(data['price'])
	if ProfileBus.profile.maps[map_index]:
		map_buy_button.text = "W posiadaniu"
		map_buy_button.disabled = true
		map_lock_icon.hide()
	else:
		map_buy_button.text = "Kup"
		map_buy_button.disabled = false
		map_lock_icon.show()
	if SignalBus.ch_unlock_maps:
		map_price.text = "The Price is Right"


func _update_milks_count() -> void:
	milks.text = str(ProfileBus.profile.milks)


func _check_achievement() -> void:
	var serious_business := true
	var globetrotter := true
	for skin in ProfileBus.profile.skins:
		if not skin:
			serious_business = false
			break
	if serious_business:
		AchievementSystem.call_achievement("serious_business")
	for map in ProfileBus.profile.maps:
		if not map:
			globetrotter = false
			break
	if globetrotter:
		AchievementSystem.call_achievement("globetrotter")

func _on_back_button_pressed():
	# gdlint:ignore=private-method-call
	$"../"._on_back_button_pressed()
