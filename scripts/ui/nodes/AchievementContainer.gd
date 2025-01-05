class_name AchievementContainer extends VBoxContainer

var achievement_index: String
var achievement_anim = null
var mouse_inside = false


func _ready() -> void:
	if has_node("./AchievementIcon/animation_glow"):
		achievement_anim = get_node("./AchievementIcon/animation_glow")
