extends Node

const FILENAME = "user://profile.dat"
const FILENAME_VERSION = 2

var machineid: String
var profile: Profile

func _ready() -> void:
	machineid = OS.get_unique_id().substr(SettingsBus.os_id, 8)
	print("Machine ID: %s" % machineid)
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
	print(profile.skins)
	print(profile.maps)


func get_skin_data(skin_index: int) -> Dictionary:
	var dict: Dictionary
	match(skin_index):
		profile.Skins.FIAT_PANDA:
			dict = {
				"name": "Fiat Panda",
				"texture": load("res://sprites/Panda_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/Panda.tres"),
				"community_made": false,
				"author": "",
				"price": 0,
				"y_pos_offset": 0.0,
				"scale": 0.95,
			}
		profile.Skins.VOLVO_COMBI:
			dict = {
				"name": "Volvo",
				"texture": load("res://sprites/Volvo_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/Volvo.tres"),
				"community_made": true,
				"author": "Astro",
				"price": 250,
				"y_pos_offset": 0.0,
				"scale": 1.0,
			}
		profile.Skins.REAL_PANDA:
			dict = {
				"name": "Panda",
				"texture": load("res://sprites/RealPanda_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/RealPanda.tres"),
				"community_made": true,
				"author": "Astro",
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
				"author": "",
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
				"author": "",
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
				"author": "Astro",
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
				"author": "Astro",
				"price": 400,
				"y_pos_offset": 0.0,
				"scale": 1.0,
			}
		profile.Skins.EMO_PANDA:
			dict = {
				"name": "Emo Panda",
				"texture": load("res://sprites/EmoPanda_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/EmoPanda.tres"),
				"community_made": true,
				"author": "Astro",
				"price": 300,
				"y_pos_offset": 0.0,
				"scale": 0.95,
			}
		profile.Skins.LOWRIDER:
			dict = {
				"name": "Lowrider",
				"texture": load("res://sprites/Lowrider_0002.png"),
				"spriteframe": load("res://sprites/spriteframes/Lowrider.tres"),
				"community_made": true,
				"author": "Astro",
				"price": 600,
				"y_pos_offset": 12.0,
				"scale": 1.00,
			}
		profile.Skins.OPTIMUS_PRIME:
			dict = {
				"name": "Optimus Prime",
				"texture": load("res://sprites/OptimusPrime_0002.png"),
				"spriteframe": load("res://sprites/spriteframes/OptimusPrime.tres"),
				"community_made": true,
				"author": "Astro",
				"price": 500,
				"y_pos_offset": 0.0,
				"scale": 1.05,
			}
		profile.Skins.FRIDGE:
			dict = {
				"name": "Lodówkarz",
				"texture": load("res://sprites/Fridge_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/Fridge.tres"),
				"community_made": true,
				"author": "Astro",
				"price": 600,
				"y_pos_offset": 0.0,
				"scale": 1.10,
			}
	return dict


func get_map_data(map_index: int) -> Dictionary:
	var dict: Dictionary
	match(map_index):
		profile.Maps.FOREST:
			dict = {
				"name": "Las Borowski",
				"texture": load("res://images/maps/ForestMap.png"),
				"scene": load("res://nodes/maps/ForestMap.tscn"),
				"community_made": false,
				"author": "",
				"price": 0,
			}
		profile.Maps.SAHARA:
			dict = {
				"name": "Wydmy Egipskie",
				"texture": load("res://images/maps/SaharaMap.png"),
				"scene": load("res://nodes/maps/SaharaMap.tscn"),
				"community_made": false,
				"author": "",
				"price": 400,
			}
		profile.Maps.LUNAR_CONFLICT:
			dict = {
				"name": "Konflikt księżycowy",
				"texture": load("res://images/maps/LunarConflictMap.png"),
				"scene": load("res://nodes/maps/LunarConflictMap.tscn"),
				"community_made": false,
				"author": "Coco Jambo on Century Old Organs",
				"price": 200,
			}
		profile.Maps.CITY:
			dict = {
				"name": "Metropolia Halembska",
				"texture": load("res://images/maps/CityMap.webp"),
				"scene": load("res://nodes/maps/CityMap.tscn"),
				"community_made": false,
				"author": "",
				"price": 800,
			}
	return dict


func load_profile_from_file() -> Profile:
	var data
	# Generate clean profile if file doesn't exists
	if not FileAccess.file_exists(FILENAME):
		data = _generate_clean_profile()
		return data

	var file = FileAccess.open(FILENAME, FileAccess.READ)
	var file_version = file.get_16()
	if file_version == 2:
		data = Profile.new(
				file.get_pascal_string(),
				file.get_pascal_string(),
				file.get_32(),
				file.get_32(),
				file.get_64(),
				file.get_32(),
				file.get_32(),
				file.get_64(),
				file.get_float(),
				file.get_float(),
				file.get_float(),
				file.get_float(),
				file.get_32(),
				file.get_64(),
				file.get_64(),
				file.get_64(),
				file.get_64(),
				file.get_var(),
				file.get_var(),
				file.get_8(),
				file.get_8(),
		)
	# FILE_VERSION 1: Missing playername and machineid vars
	elif file_version == 1:
		data = Profile.new(
				"",
				machineid,
				file.get_32(),
				file.get_32(),
				file.get_64(),
				file.get_32(),
				file.get_32(),
				file.get_64(),
				file.get_float(),
				file.get_float(),
				file.get_float(),
				file.get_float(),
				file.get_32(),
				file.get_64(),
				file.get_64(),
				file.get_64(),
				file.get_64(),
				file.get_var(),
				file.get_var(),
				file.get_8(),
				file.get_8(),
		)
	if data is Profile:
		machineid = data.machineid
		print("Machine ID loaded from save file: %s" % data.machineid)
		return data

	return null


func save_profile_to_file() -> void:
	if not SettingsBus.cheats:
		var file = FileAccess.open(FILENAME, FileAccess.WRITE)
		file.store_16(FILENAME_VERSION)
		file.store_pascal_string(profile.playername)
		file.store_pascal_string(profile.machineid)
		file.store_32(profile.games)
		file.store_32(profile.runs)
		file.store_64(profile.milks_total)
		file.store_32(profile.milks_single_run)
		file.store_32(profile.time_played_single_run)
		file.store_64(profile.time_played_sum)
		file.store_float(profile.distance_sum)
		file.store_float(profile.distance_single_run)
		file.store_float(profile.top_speed)
		file.store_float(profile.top_speed_avg)
		file.store_32(profile.milks)
		file.store_64(profile.powerups_ram)
		file.store_64(profile.powerups_slowmotion)
		file.store_64(profile.powerups_semaglutide)
		file.store_64(profile.powerups_milkyway)
		file.store_var(profile.skins)
		file.store_var(profile.maps)
		file.store_8(profile.chosen_skin)
		file.store_8(profile.chosen_map)
		file.close()


func _generate_clean_profile() -> Profile:
	return Profile.new(
		"",
		machineid,
		0,
		0,
		0,
		0,
		0,
		0,
		0.0,
		0.0,
		0.0,
		0.0,
		0,
		0,
		0,
		0,
		0,
		{0: true},
		{0: true},
		Profile.Skins.FIAT_PANDA,
		Profile.Maps.FOREST,
	)


func _add_missing_skins_and_maps() -> void:
	for skin in Profile.Skins.values():
		if skin not in profile.skins:
			profile.skins[skin] = false
	for map in Profile.Maps.values():
		if map not in profile.maps:
			profile.maps[map] = false
