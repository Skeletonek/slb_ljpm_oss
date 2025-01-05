extends CanvasLayer

@onready var master_slider:HSlider = $TabContainer/Audio/VBoxContainer/MasterSlider
@onready var sfx_slider:HSlider = $TabContainer/Audio/VBoxContainer/SFXSlider
@onready var music_slider:HSlider = $TabContainer/Audio/VBoxContainer/MusicSlider
@onready var ui_scaling_slider:HSlider = $TabContainer/Grafika/VBoxContainer/UIScaling/Container/TextureRect/UIScalingSlider
@onready var fullscreen_button:Button = $TabContainer/Grafika/VBoxContainer/Screen/FullScreenButton
@onready var graphics_api_button:OptionButton = $TabContainer/Grafika/VBoxContainer/Screen2/GraphicsAPIButton
@onready var graphics_api_restart:Label = $TabContainer/Grafika/VBoxContainer/Screen2/GraphicsAPIRestartLabel
@onready var tch_tap_button:TextureButton = $TabContainer/Rozgrywka/VBoxContainer/TouchScreenControls/HBoxContainer/Tap/TextureButton
@onready var tch_swipe_button:TextureButton = $TabContainer/Rozgrywka/VBoxContainer/TouchScreenControls/HBoxContainer/Swipe/TextureButton
@onready var tch_vbuttons_button:TextureButton = $TabContainer/Rozgrywka/VBoxContainer/TouchScreenControls/HBoxContainer/VirtualButtons/TextureButton
@onready var reduced_motion_button:Button = $"TabContainer/Dostępność/VBoxContainer/ReducedMotion/Button"
@onready var easier_font_button:Button = $"TabContainer/Dostępność/VBoxContainer/EasierFont/Button"
@onready var easier_font_restart:Label = $"TabContainer/Dostępność/VBoxContainer/EasierFont/RestartLabel"
@onready var fullscreen_android_info:Label = $TabContainer/Grafika/VBoxContainer/Screen/FullScreenLabelDesc
@onready var back_button:Button = $MarginContainer/BackButton

func _ready():
	master_slider.value = SettingsBus.master_volume
	sfx_slider.value = SettingsBus.sfx_volume
	music_slider.value = SettingsBus.music_volume
	ui_scaling_slider.value = SettingsBus.ui_scaling
	if OS.get_name() != "Android":
		fullscreen_button.set_pressed_no_signal_custom(SettingsBus.fullscreen)
	else:
		fullscreen_button.disabled = true
		fullscreen_android_info.visible = true
	graphics_api_button.get_popup().id_pressed.connect(_on_graphics_api_pressed)
	if SettingsBus.cfg_rendering_method == "gl_compatibility":
		graphics_api_button.selected = 1
	match(SettingsBus.touchscreen_control):
		SettingsBus.TOUCHSCREEN_CONTROL_MODE.Tap:
			tch_tap_button.set_pressed_no_signal(true)
		SettingsBus.TOUCHSCREEN_CONTROL_MODE.Swipe:
			tch_swipe_button.set_pressed_no_signal(true)
		SettingsBus.TOUCHSCREEN_CONTROL_MODE.VButtons:
			tch_vbuttons_button.set_pressed_no_signal(true)
	easier_font_button.set_pressed_no_signal_custom(SettingsBus.easier_font)
	reduced_motion_button.set_pressed_no_signal_custom(SettingsBus.reduced_motion)


func _on_master_slider_value_changed(value):
	SettingsBus.master_volume=value
	AudioServer.set_bus_volume_db(0, linear_to_db(value)*2)


func _on_master_slider_drag_ended(_value_changed):
	print(linear_to_db(master_slider.value)*2)


func _on_sfx_slider_value_changed(value):
	SettingsBus.sfx_volume=value
	AudioServer.set_bus_volume_db(1, linear_to_db(value)*2)


func _on_sfx_slider_drag_ended(_value_changed):
	$SFXTest.play()
	print(linear_to_db(sfx_slider.value)*2)


func _on_music_slider_value_changed(value):
	SettingsBus.music_volume=value
	AudioServer.set_bus_volume_db(3, linear_to_db(value)*2)


func _on_full_screen_button_toggled(button_pressed):
	SettingsBus.fullscreen=button_pressed
	var window_mode = (
		DisplayServer.WINDOW_MODE_FULLSCREEN if button_pressed
		else DisplayServer.WINDOW_MODE_WINDOWED
		)
	SettingsBus.cfg_window_mode = window_mode
	SettingsBus.save_override()
	DisplayServer.window_set_mode(window_mode)


func _on_graphics_api_pressed(id: int):
	match(id):
		0:
			SettingsBus.cfg_rendering_method = "mobile"
			#graphics_api_button.text = "Vulkan"
		1:
			SettingsBus.cfg_rendering_method = "gl_compatibility"
			#graphics_api_button.text = "OpenGL"
		_:
			push_error("Unknown entry. Graphics API Button is broken. How?")
	SettingsBus.save_override()
	graphics_api_restart.show()


func _on_ui_scaling_slider_value_changed(value):
	SettingsBus.ui_scaling = value
	get_tree().root.content_scale_factor = value


func _on_tch_tap_toggled(button_pressed):
	_unpress_tch_buttons()
	SettingsBus.touchscreen_control = SettingsBus.TOUCHSCREEN_CONTROL_MODE.Tap
	tch_tap_button.set_pressed_no_signal(true)


func _on_tch_swipe_toggled(button_pressed):
	_unpress_tch_buttons()
	SettingsBus.touchscreen_control = SettingsBus.TOUCHSCREEN_CONTROL_MODE.Swipe
	tch_swipe_button.set_pressed_no_signal(true)


func _on_tch_vbuttons_toggled(button_pressed):
	_unpress_tch_buttons()
	SettingsBus.touchscreen_control = SettingsBus.TOUCHSCREEN_CONTROL_MODE.VButtons
	tch_vbuttons_button.set_pressed_no_signal(true)


func _unpress_tch_buttons():
	tch_tap_button.set_pressed_no_signal(false)
	tch_swipe_button.set_pressed_no_signal(false)
	tch_vbuttons_button.set_pressed_no_signal(false)


func _on_reduced_motion_button_toggled(button_pressed):
	SettingsBus.reduced_motion = button_pressed
	SignalBus.reduce_motion.emit(button_pressed)


func _on_easier_font_button_toggled(button_pressed):
	SettingsBus.easier_font = button_pressed
	if button_pressed:
		ThemeDB.get_project_theme().set_default_font(load("res://theme/fonts/OpenDyslexic-Regular.otf"))
#		get_tree().root.add_theme_font_override("theme", load("res://theme/fonts/OpenDyslexic-Regular.otf"))
	else:
		ThemeDB.get_project_theme().set_default_font(load("res://theme/fonts/PixelifySans-Bold.ttf"))
	easier_font_restart.show()


func _on_back_button_pressed():
	SettingsBus.save_config()
	$"../"._on_back_button_pressed()
