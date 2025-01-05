extends CanvasLayer

@export var scroll_container: ScrollContainer
@export var scroll_direction := 20.0

var scroll_vertical := 0.0
var scroll_halt := false


func _ready() -> void:
	var scrollbar = scroll_container.get_v_scroll_bar()
	scrollbar.gui_input.connect(_on_scroll_container_gui_input)


func _process(delta: float) -> void:
	if visible && not scroll_halt:
		scroll_vertical += scroll_direction * delta
		var max_value = scroll_container.get_v_scroll_bar().max_value - scroll_container.size.y
		if scroll_vertical >= max_value || scroll_vertical <= 0:
			scroll_direction *= -1
		scroll_container.scroll_vertical = int(scroll_vertical)


func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				scroll_halt = true
			else:
				scroll_vertical = scroll_container.scroll_vertical
				scroll_halt = false


func _on_skeletonek_logo_click(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			OS.shell_open("https://www.skeletonek.com")


func _on_godot_logo_click(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			OS.shell_open("https://godotengine.org")


func _on_back_button_pressed() -> void:
	# gdlint:ignore=private-method-call
	$"../"._on_back_button_pressed()
