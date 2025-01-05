extends Node

const FILENAME = "user://profile.dat"

var profile: Profile

func _ready() -> void:
	var loaded_profile = load_profile_from_file()
	if loaded_profile:
		profile = loaded_profile
	else:
		# Whoops!
		SettingsBus.show_os_alert("ERROR WHILE LOADING A PROFILE FILE",
			"Couldn't load a profile file.\n" +
			"Your profile data will be erased!\n" +
			"Terminate the game now if you don't want to override your profile file!"
		)
		profile = _generate_clean_profile()
	_add_missing_skins_and_maps()


func get_skin_data(skin_index: int) -> Dictionary:
	var dict: Dictionary
	match(skin_index):
		profile.Skins.FIAT_PANDA:
			dict = {
				"name": "Fiat Panda",
				"texture": load("res://sprites/Panda_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/Panda.tres"),
				"community_made": false,
				"price": 0,
				"y_pos_offset": 0.0,
				"scale": 1.0,
			}
		# profile.Skins.VOLVO_COMBI:
		# 	dict = {
		# 		"name": "Volvo",
		# 		"texture": null,
		# 		"spriteframe": null,
		# 		"community_made": false,
		# 		"price": 250,
		# 		"y_pos_offset": 0.0,
		# 		"scale": 1.0,
		# 	}
		profile.Skins.REAL_PANDA:
			dict = {
				"name": "Panda",
				"texture": load("res://sprites/RealPanda_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/RealPanda.tres"),
				"community_made": true,
				"price": 500,
				"y_pos_offset": -8.0,
				"scale": 1.0,
			}
		profile.Skins.PIGTANK:
			dict = {
				"name": "Świnioczołg",
				"texture": load("res://sprites/Pigtank_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/Pigtank.tres"),
				"community_made": false,
				"price": 400,
				"y_pos_offset": 0.0,
				"scale": 1.0,
			}
		profile.Skins.LUNAR_ROVER:
			dict = {
				"name": "Łazik księżycowy",
				"texture": load("res://sprites/LunarRover_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/LunarRover.tres"),
				"community_made": false,
				"price": 200,
				"y_pos_offset": -4.0,
				"scale": 0.88,
			}
		profile.Skins.CONTENT_MAKER:
			dict = {
				"name": "Kontenciarz",
				"texture": load("res://sprites/ContentMaker_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/ContentMaker.tres"),
				"community_made": true,
				"price": 800,
				"y_pos_offset": -24.0,
				"scale": 1.0,
			}
		profile.Skins.LUKASZCZYK_ON_HORSE:
			dict = {
				"name": "Łukaszczyk na koniu",
				"texture": load("res://sprites/LukaszczykOnAHorse_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/LukaszczykOnAHorse.tres"),
				"community_made": true,
				"price": 400,
				"y_pos_offset": 0.0,
				"scale": 1.0,
			}
	return dict


func get_map_data(map_index: int) -> Dictionary:
	var dict: Dictionary
	match(map_index):
		profile.Maps.FOREST:
			dict = {
				"name": "Las",
				"texture": load("res://images/maps/ForestMap.png"),
				"scene": load("res://nodes/maps/ForestMap.tscn"),
				"community_made": false,
				"price": 0,
			}
		profile.Maps.SAHARA:
			dict = {
				"name": "Pustynia",
				"texture": load("res://images/maps/SaharaMap.png"),
				"scene": load("res://nodes/maps/SaharaMap.tscn"),
				"community_made": false,
				"price": 400,
			}
		profile.Maps.LUNAR_CONFLICT:
			dict = {
				"name": "Konflikt księżycowy",
				"texture": load("res://images/maps/LunarConflictMap.png"),
				"scene": load("res://nodes/maps/LunarConflictMap.tscn"),
				"community_made": false,
				"price": 200,
			}
	return dict


func load_profile_from_file() -> Profile:
	var data
	# Generate clean profile if file doesn't exists
	if not FileAccess.file_exists(FILENAME):
		data = _generate_clean_profile()
		return data

	var file = FileAccess.open(FILENAME, FileAccess.READ)
	data = Profile.new(
			file.get_32(),
			file.get_32(),
			file.get_32(),
			file.get_64(),
			file.get_float(),
			file.get_32(),
			file.get_32(),
			file.get_32(),
			file.get_var(),
			file.get_var(),
			file.get_8(),
			file.get_8(),
	)
	if data is Profile:
		return data

	return null


func save_profile_to_file() -> void:
	if not SettingsBus.cheats:
		var file = FileAccess.open(FILENAME, FileAccess.WRITE)
		file.store_32(profile.milks_total)
		file.store_32(profile.milks_single_run)
		file.store_32(profile.time_played_single_run)
		file.store_64(profile.time_played_sum)
		file.store_float(profile.top_speed)
		file.store_32(profile.avg_speed)
		file.store_32(profile.meters_driven)
		file.store_32(profile.milks)
		file.store_var(profile.skins)
		file.store_var(profile.maps)
		file.store_8(profile.chosen_skin)
		file.store_8(profile.chosen_map)
		file.close()


func _generate_clean_profile() -> Profile:
	return Profile.new(
		0,
		0,
		0,
		0,
		0.0,
		0,
		0,
		0,
		[true],
		[true],
		Profile.Skins.FIAT_PANDA,
		Profile.Maps.FOREST,
	)


func _add_missing_skins_and_maps() -> void:
	var skins_size = profile.Skins.size()
	var maps_size = profile.Maps.size()
	var skins_unlocked_size = profile.skins.size()
	var maps_unlocked_size = profile.maps.size()

	var skins_diff = skins_size - skins_unlocked_size
	var maps_diff = maps_size - maps_unlocked_size

	for x in range(0, skins_diff):
		profile.skins.append(false)
	for x in range(0, maps_diff):
		profile.maps.append(false)

