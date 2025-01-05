extends Node
# gdlint:disable=duplicated-load

##### Achievement schema: #####
# Title: string
# Description: string
# Icon: preloaded resource
# Is hidden?: boolean

const ACHIEVEMENT_LIST = {
	"lactose_intolerant": [
		"Nietolerancja laktozy",
		"Jedź przez minutę i nie zbierz żadnego mleka",
		preload("res://images/achievement_icons/LactoseIntolerant.webp"),
		false
		],
	"milk_100": [
		"Wróciłem z mlekiem!",
		"Zbierz łącznie 100 sztuk mleka",
		preload("res://images/achievement_icons/Milk100.webp"),
		false
		],
	"milk_500": [
		"Mleko było na promocji!",
		"Zbierz łącznie 500 sztuk mleka",
		preload("res://images/achievement_icons/Milk500.webp"),
		false
		],
	"milk_1000": [
		"Otwieramy mleczarnie!",
		"Zbierz łącznie 1000 sztuk mleka",
		preload("res://images/achievement_icons/Milk1000.webp"),
		false
		],
	"speed_110": [
		"To tyle potrafi?",
		"Osiągnij prędkość 110 km/h",
		preload("res://images/achievement_icons/Speed110.webp"),
		false
		],
	"speed_150": [
		"Jakim cudem to się nie rozleciało?!",
		"Osiągnij prędkość 150 km/h",
		preload("res://images/achievement_icons/Speed150.webp"),
		false
		],
	# "volvo_combi": [
	# 	"Volvo pls fix",
	# 	"Ukończ jedną rozgrywkę w skórce Volvo",
	# 	preload("res://images/icons/slb2icon.png"),
	# 	false
	# 	],
	"real_panda": [
		"Smacznego bambusa!",
		"Ukończ jedną rozgrywkę w skórce Pandy",
		preload("res://images/achievement_icons/RealPanda.webp"),
		false
		],
	"pigtank": [
		"World of Pigtanks",
		"Ukończ jedną rozgrywkę w skórce Świnioczołgu",
		preload("res://images/achievement_icons/Pigtank.webp"),
		false
		],
	"lunar_rover": [
		"aeiou",
		"Ukończ jedną rozgrywkę w Łaziku Księzycowym",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"content_maker": [
		"Gwiazda internetu",
		"Ukończ jedną rozgrywkę w skórce Kontenciarza",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"lukaszczyk_on_horse": [
		"Jaskółka przeniosłaby orzech kokosowy?",
		"Ukończ jedną rozgrywkę w skórce Łukaszczyka na koniu",
		preload("res://images/achievement_icons/LukaszczykOnHorse.webp"),
		false
		],
	"serious_business": [
		"Poważny biznes",
		"Kup wszystkie skórki w sklepie",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"sahara": [
		"Lampa jak sk...",
		"Ukończ jedną rozgrywkę na mapie sahary",
		preload("res://images/icons/slb2icon.png"),
		false
		],
	"lunar_conflict": [
		"USA vs. ZSRR",
		"Ukończ jedną rozgrywkę na mapie konfliktu księżycowego",
		preload("res://images/achievement_icons/LunarConflict.webp"),
		false
		],
	"globetrotter": [
		"Obieżyświat",
		"Kup wszystkie mapy w sklepie",
		preload("res://images/achievement_icons/Globetrotter.webp"),
		false
		],
	"offroad": [
		"Myślałem że to rajd przełajowy...",
		"Zjedź z drogi",
		preload("res://images/achievement_icons/Offroad.webp"),
		false
		],
	"rick_roll": [
		"Never gonna give you up",
		"Kliknij na Michała w menu głównym",
		preload("res://images/achievement_icons/RickRoll.webp"),
		true
		],
	"rick_rolled": [
		"I won't give Rick up !11! <3 <3",
		"Obejrzyj cały teledysk z Rick'em Astley'em",
		preload("res://images/achievement_icons/RickRoll.webp"),
		true
		],
}
