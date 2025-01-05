class_name Profile

enum Skins {
	FIAT_PANDA=0,
	VOLVO_COMBI=1,
	REAL_PANDA=2,
	PIGTANK=3,
	LUNAR_ROVER=4,
	CONTENT_MAKER=5,
	LUKASZCZYK_ON_HORSE=6,
	EMO_PANDA=7,
}

enum Maps {
	FOREST=0,
	SAHARA=1,
	LUNAR_CONFLICT=2,
	CITY=3,
}

var playername: String
var machineid: String
var games: int
var runs: int
var milks_total: int
var milks_single_run: int
var time_played_single_run: int
var time_played_sum: int
var distance_sum: float
var distance_single_run: float
var top_speed: float
var top_speed_avg: float

var milks: int
var powerups_ram: int
var powerups_slowmotion: int
var powerups_semaglutide: int
var powerups_milkyway: int
var skins: Dictionary
var maps: Dictionary

var chosen_skin: Skins = Skins.FIAT_PANDA
var chosen_map: Maps = Maps.FOREST

# gdlint:ignore=function-arguments-number
func _init(
		_playername: String,
		_machineid: String,
		_games: int,
		_runs: int,
		_milks_total: int,
		_milks_single_run: int,
		_time_played_single_run: int,
		_time_played_sum: int,
		_distance_sum: float,
		_distance_single_run: float,
		_top_speed: float,
		_top_speed_avg: float,
		_milks: int,
		_powerups_ram: int,
		_powerups_slowmotion: int,
		_powerups_semaglutide: int,
		_powerups_milkyway: int,
		_skins: Dictionary,
		_maps: Dictionary,
		_chosen_skin: Skins,
		_chosen_map: Maps,
) -> void:
	playername = _playername
	if playername.length() > 36:
		playername = playername.left(36)
	machineid = _machineid
	if machineid.length() > 8:
		machineid = machineid.left(8)
	games = _games
	runs = _runs
	milks_total = _milks_total
	milks_single_run = _milks_single_run
	time_played_single_run = _time_played_single_run
	time_played_sum = _time_played_sum
	distance_sum = _distance_sum
	distance_single_run = _distance_single_run
	top_speed = _top_speed
	top_speed_avg = _top_speed_avg
	milks = _milks
	powerups_ram = _powerups_ram
	powerups_slowmotion = _powerups_slowmotion
	powerups_semaglutide = _powerups_semaglutide
	powerups_milkyway = _powerups_milkyway
	skins = _skins
	maps = _maps
	chosen_skin = _chosen_skin
	chosen_map = _chosen_map


func get_full_playername() -> String:
	return playername + "#" + machineid


func change_playername(_playername: String) -> void:
	playername = _playername.replace("\n", "")


func add_game() -> void:
	games += 1


func add_run() -> void:
	runs += 1


func add_milks(_milks: int) -> void:
	milks_total += _milks
	milks += _milks
	if milks_single_run < _milks:
		milks_single_run = _milks


func add_powerups(_powerups: Dictionary) -> void:
	powerups_ram += _powerups[PowerupClass.Powerups.RAM]
	powerups_slowmotion += _powerups[PowerupClass.Powerups.SLOWMOTION]
	powerups_semaglutide += _powerups[PowerupClass.Powerups.SEMAGLUTIDE]
	powerups_milkyway += _powerups[PowerupClass.Powerups.MILKYWAY]


func add_time(_time: int) -> void:
	time_played_sum += _time
	if time_played_single_run < _time:
		time_played_single_run = _time


## This function requires to use add_run function beforehand!
func add_speed(_speed: float) -> void:
	if top_speed < _speed:
		top_speed = _speed
	top_speed_avg = top_speed_avg + ((_speed - top_speed_avg) / runs)


func add_distance(_distance: float) -> void:
	distance_sum += _distance
	if distance_single_run < _distance:
		distance_single_run = _distance


func change_skin(_skin: Skins) -> bool:
	if skins[_skin] == true:
		chosen_skin = _skin
		return true
	return false


func change_map(_map: Maps) -> bool:
	if maps[_map] == true:
		chosen_map = _map
		return true
	return false
