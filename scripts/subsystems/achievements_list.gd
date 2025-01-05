extends Node

##### Achievement schema: #####
# Title: string
# Description: string
# Icon: preloaded resource
# Is hidden?: boolean

const ACHIEVEMENT_LIST = {
	"test": [
		"Testowe osiągnięcie",
		"To jest testowe osiągnięcie",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"test2": [
		"Testowe osiągnięcie 2",
		"To jest drugie testowe osiągnięcie bo jedno to było za mało",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"test3": [
		"Testowe osiągnięcie 3",
		"To jest trzecie testowe osiągnięcie bo tak",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"hidden": [
		"Testowe ukryte osiągnięcie",
		"To jest testowe osiągnięcie które jest ukryte",
		preload("res://images/icons/slb2icon.png"),
		true
		],
	"paradise_island": [
		"Ty śpiochu...",
		"Wczuj się w rytm muzyki swojego alarmu",
		preload("res://images/achievement_icons/paradise_island.webp"),
		false
		],
	"fatty_breakfast": [
		"Miałeś pójść po pół paczki żelek!",
		"Zrób sobie potwornie niezdrowe śniadanie",
		preload("res://images/achievement_icons/fatty_breakfast.webp"),
		false
		],
	"dryer_ending": [
		"Z każdym dniem oddalamy się od Boga...",
		"Zorganizuj sobie trójkącik z... suszarkami? Co do k****?!",
		preload("res://images/achievement_icons/dryer_ending.webp"),
		false
		],
}
