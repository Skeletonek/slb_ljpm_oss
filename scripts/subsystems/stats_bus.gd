extends Node

const FILENAME = "user://profile.dat"

var profile: Profile

func _ready() -> void:
	var loaded_profile = load_profile_from_file()
	if loaded_profile:
		profile = loaded_profile
	# Generate clean profile if file doesn't exists
	else:
		profile = Profile.new(
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			[true, false, false, false],
			[true, false],
			Profile.Skins.FIAT_PANDA,
			Profile.Maps.FOREST,
		)


func load_profile_from_file() -> Profile:
	if not FileAccess.file_exists(FILENAME):
		return null
	var file = FileAccess.open(FILENAME, FileAccess.READ)
	var data = Profile.new(
			file.get_32(),
			file.get_32(),
			file.get_32(),
			file.get_64(),
			file.get_32(),
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
	file.store_32(profile.top_speed)
	file.store_32(profile.avg_speed)
	file.store_32(profile.meters_driven)
	file.store_32(profile.milks)
	file.store_var(profile.skins)
	file.store_var(profile.maps)
	file.store_8(profile.chosen_skin)
	file.store_8(profile.chosen_map)
	file.close()
