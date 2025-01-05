class_name Profile

enum Skins {
	FIAT_PANDA,
	VOLVO_COMBI,
	REAL_PANDA,
	PIGTANK,
	LUNAR_ROVER,
}

enum Maps {
	FOREST,
	SAHARA,
	LUNAR_CONFLICT
}

var milks_total: int
var milks_single_run: int
var time_played_single_run: int
var time_played_sum: int
var top_speed: int
var avg_speed: int
var meters_driven: int

var milks: int
var skins: Array[bool]
var maps: Array[bool]

var chosen_skin: Skins
var chosen_map: Maps

# gdlint:ignore=function-arguments-number
func _init(
		_milks_total: int,
		_milks_single_run: int,
		_time_played_single_run: int,
		_time_played_sum: int,
		_top_speed: int,
		_avg_speed: int,
		_meters_driven: int,
		_milks: int,
		_skins: Array[bool],
		_maps: Array[bool],
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
	if milks_single_run < _milks:
		milks_single_run = _milks


func add_time(_time: int) -> void:
	time_played_sum += _time
	if time_played_single_run < _time:
		time_played_single_run = _time


func add_speed(_speed: int) -> void:
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
