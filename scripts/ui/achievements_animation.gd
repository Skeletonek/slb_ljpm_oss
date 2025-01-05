extends Control

enum {ACHV_NAME, ACHV_DESC, ACHV_ICON, ACHV_HIDDEN}

enum {IDLE, SLIDE_DOWN, SLIDE_UP, WAIT}

const ANIMATION_SPEED := 300
const ANIMATION_WAIT := 5

@export var anim_max_y := 0
var anim_min_y: float

var animation_state := IDLE
var animation_vector := Vector2.ZERO
var animation_timer := Timer.new()

@onready
var achv_player = $AchvPlayer
@onready
var achv_title = $HBoxContainer/MarginContainer2/VBoxContainer/AchvTitleLabel
@onready
var achv_desc = $HBoxContainer/MarginContainer2/VBoxContainer/AchvDescLabel
@onready
var achv_icon = $HBoxContainer/MarginContainer/AchvIcon

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_min_y = position.y
	animation_timer.timeout.connect(_wait_for_achievement_end)
	add_child(animation_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation_state == SLIDE_DOWN or animation_state == SLIDE_UP:
		position += animation_vector * ANIMATION_SPEED * delta

		# Arriving to end
		if position.y >= anim_max_y:
			animation_state = WAIT
			animation_vector = Vector2.ZERO
			position.y = anim_max_y
			animation_timer.start(ANIMATION_WAIT)
		elif position.y <= anim_min_y:
			animation_state = IDLE
			animation_vector = Vector2.ZERO
			position.y = anim_min_y


func show_achievement(achievement: Array):
	var title = achievement[ACHV_NAME]
	var description = achievement[ACHV_DESC]
	var icon = achievement[ACHV_ICON]

	achv_title.text = title
	achv_desc.text = description
	achv_icon.texture = icon
	animation_state = SLIDE_DOWN
	animation_vector = Vector2.DOWN
	achv_player.play()


func _wait_for_achievement_end():
	animation_state = SLIDE_UP
	animation_vector = Vector2.UP
	animation_timer.stop()
