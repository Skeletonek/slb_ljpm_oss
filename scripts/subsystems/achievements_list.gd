extends Node
# gdlint:disable=duplicated-load

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
	"lactose_intolerant": [
		"Nietolerancja laktozy",
		"Jedź przez minutę i nie zbierz żadnego mleka",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"milk_100": [
		"Wróciłem z mlekiem!",
		"Zbierz łącznie 100 sztuk mleka",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"milk_500": [
		"Mleko było na promocji!",
		"Zbierz łącznie 500 sztuk mleka",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"milk_1000": [
		"Otwieramy mleczarnie!",
		"Zbierz łącznie 1000 sztuk mleka",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"speed_110": [
		"Te auto tyle potrafi?",
		"Osiągnij prędkość 110 km/h",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"speed_150": [
		"Jakim cudem to się nie rozleciało?!",
		"Osiągnij prędkość 150 km/h",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"serious_business": [
		"Poważny biznes",
		"Kup wszystkie skórki w sklepie",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"offroad": [
		"Myślałem że to rajd przełajowy...",
		"Zjedź z drogi",
		preload("res://images/icons/slb2icon.png"),
		false
		]
}
