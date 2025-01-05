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

var milks_total: int
var milks_single_run: int
var time_played_single_run: int
var time_played_sum: int
var top_speed: float
var avg_speed: int
var meters_driven: int

var milks: int
var skins: Dictionary
var maps: Dictionary

var chosen_skin: Skins = Skins.FIAT_PANDA
var chosen_map: Maps = Maps.FOREST

# gdlint:ignore=function-arguments-number
func _init(
		_milks_total: int,
		_milks_single_run: int,
		_time_played_single_run: int,
		_time_played_sum: int,
		_top_speed: float,
		_avg_speed: int,
		_meters_driven: int,
		_milks: int,
		_skins: Dictionary,
		_maps: Dictionary,
		_chosen_skin: Skins,
		_chosen_map: Maps,
) -> void:
	milks_total = _milks_total
	milks_single_run = _milks_single_run
	meters_driven = _meters_driven
	time_played_single_run = _time_played_single_run
	time_played_sum = _time_played_sum
	top_speed = _top_speed
	avg_speed = _avg_speed
	milks = _milks
	skins = _skins
	maps = _maps
	chosen_skin = _chosen_skin
	chosen_map = _chosen_map


func add_milks(_milks: int) -> void:
	milks_total += _milks
	milks += _milks
	if milks_single_run < _milks:
		milks_single_run = _milks


func add_time(_time: int) -> void:
	time_played_sum += _time
	if time_played_single_run < _time:
		time_played_single_run = _time


func add_speed(_speed: float) -> void:
	if top_speed < _speed:
		top_speed = _speed


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
