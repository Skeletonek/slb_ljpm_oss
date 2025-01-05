extends CanvasLayer

enum {
	ACHV_NAME,
	ACHV_DESC,
	ACHV_ICON,
	ACHV_HIDDEN
}

enum {
	ACHV_COMPLETE,
	ACHV_DATE,
}

var achievement_container = preload("res://scenes/instances/achievement_container.tscn")
var achievement_animation = preload("res://scenes/instances/animation_glow.tscn")
var locked_achv_icon = preload("res://images/icons/locked.png")
@onready var achv_panel = $PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/HFlowContainer
@onready var achv_details = $AchvDetailsView

func _ready():
	SignalBus.refresh_achievements_viewer.connect(_refresh)
	_generate_unlocked_achievements()
	_generate_locked_achievements()
	_generate_hidden_achievements()


func _refresh():
	for child in achv_panel.get_children():
		child.queue_free()
	_generate_unlocked_achievements()
	_generate_locked_achievements()
	_generate_hidden_achievements()


func _generate_unlocked_achievements():
	for x in AchievementSystem.ACHIEVEMENT_LIST:
		if AchievementSystem.achievement_completed[x][ACHV_COMPLETE]:
			if AchievementSystem.achievement_recently_completed[x]:
				_generate_achievement_containers(
					x,
					AchievementSystem.ACHIEVEMENT_LIST[x][ACHV_NAME],
					AchievementSystem.ACHIEVEMENT_LIST[x][ACHV_ICON],
					true
					)
			else:
				_generate_achievement_containers(
					x,
					AchievementSystem.ACHIEVEMENT_LIST[x][ACHV_NAME],
					AchievementSystem.ACHIEVEMENT_LIST[x][ACHV_ICON],
					false
					)


func _generate_locked_achievements():
	for x in AchievementSystem.ACHIEVEMENT_LIST:
		if not AchievementSystem.achievement_completed[x][ACHV_COMPLETE]:
			if not AchievementSystem.ACHIEVEMENT_LIST[x][ACHV_HIDDEN]:
				_generate_achievement_containers(
					x,
					AchievementSystem.ACHIEVEMENT_LIST[x][ACHV_NAME],
					locked_achv_icon,
					false
					)


func _generate_hidden_achievements():
	for x in AchievementSystem.ACHIEVEMENT_LIST:
		if not AchievementSystem.achievement_completed[x][ACHV_COMPLETE]:
			if AchievementSystem.ACHIEVEMENT_LIST[x][ACHV_HIDDEN]:
				_generate_achievement_containers(
					x,
					"Ukryte osiągnięcie",
					locked_achv_icon,
					false
					)


func _generate_achievement_containers(id: String, title: String, icon: CompressedTexture2D, glow: bool):
	var instance = achievement_container.instantiate()
	instance.get_node("AchievementIcon").texture = icon
	instance.get_node("AchievementTitle").text = title
	if glow:
		var anim_instance = achievement_animation.instantiate()
		instance.get_node("AchievementIcon").add_child(anim_instance)
	
	instance.achievement_index = id
	instance.gui_input.connect(_load_achv_details.bind(instance))
	achv_panel.add_child(instance)


func _load_achv_details(event, sender):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var achv_index = sender.achievement_index
			var achv_data = AchievementSystem.ACHIEVEMENT_LIST[achv_index]
			
			if sender.achievement_anim != null:
				AchievementSystem.achievement_recently_completed[achv_index] = false
				sender.achievement_anim.queue_free()
				
			if achv_data[ACHV_HIDDEN] and not (
			AchievementSystem.achievement_completed[achv_index][ACHV_COMPLETE]):
				achv_details.title.text = "Ukryte osiągnięcie"
				achv_details.desc.text = "Ukryte osiągnięcie"
				achv_details.icon.texture = locked_achv_icon # TODO: Change to hidden icon
				achv_details.date.text = "Nie odblokowano"
			else:
				achv_details.title.text = achv_data[ACHV_NAME]
				achv_details.desc.text = achv_data[ACHV_DESC]
				achv_details.icon.texture = achv_data[ACHV_ICON]
				achv_details.date.text = "Nie odblokowano" if not (
				AchievementSystem.achievement_completed[achv_index][ACHV_COMPLETE]) else (
				AchievementSystem.achievement_completed[achv_index][ACHV_DATE]
				)
			achv_details.visible = true
			print("Clicked ", sender.get_node("AchievementTitle").text)


func _process(_delta):
	pass


func _on_back_button_pressed():
	$"../"._on_back_button_pressed()
