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


func get_skin_data(skin_index: int) -> Dictionary:
	var dict: Dictionary
	match(skin_index):
		profile.Skins.FIAT_PANDA:
			dict = {
				"name": "Fiat Panda",
				"texture": load("res://sprites/Panda_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/Panda.tres"),
				"y_pos_offset": 0.0,
				"scale": 1.0,
			}
		profile.Skins.VOLVO_COMBI:
			dict = {
				"name": "Volvo",
				"texture": null,
				"spriteframe": null,
				"y_pos_offset": 0.0,
				"scale": 1.0
			}
		profile.Skins.REAL_PANDA:
			dict = {
				"name": "Panda",
				"texture": load("res://sprites/RealPanda_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/RealPanda.tres"),
				"y_pos_offset": -8.0,
				"scale": 1.25
			}
		profile.Skins.PIGTANK:
			dict = {
				"name": "Świnioczołg",
				"texture": load("res://sprites/Pigtank_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/Pigtank.tres"),
				"y_pos_offset": 0.0,
				"scale": 1.0
			}
		profile.Skins.LUNAR_ROVER:
			dict = {
				"name": "Łazik księżycowy",
				"texture": load("res://sprites/LunarRover_0001.png"),
				"spriteframe": load("res://sprites/spriteframes/LunarRover.tres"),
				"y_pos_offset": -4.0,
				"scale": 0.88
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
			}
		profile.Maps.SAHARA:
			dict = {
				"name": "Pustynia",
				"texture": load("res://images/maps/SaharaMap.png"),
				"scene": load("res://nodes/maps/SaharaMap.tscn"),
			}
		profile.Maps.LUNAR_CONFLICT:
			dict = {
				"name": "Konflikt księżycowy",
				"texture": load("res://images/maps/LunarConflictMap.png"),
				"scene": load("res://nodes/maps/LunarConflictMap.tscn"),
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
		[true, false, false, false],
		[true, false],
		Profile.Skins.FIAT_PANDA,
		Profile.Maps.FOREST,
	)
