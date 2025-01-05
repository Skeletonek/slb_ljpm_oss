extends CanvasLayer

@export_category("Graphics")
@export var fullscreen_button:Button
@export var graphics_api_button:OptionButton
@export var graphics_api_restart:Label
@export var vsync_button:OptionButton
@export var framerate_cap_input:LineEdit
@export var blur_button:Button
@export var ui_scaling_slider:HSlider

@export_category("Audio")
@export var master_slider:HSlider
@export var sfx_slider:HSlider
@export var music_slider:HSlider
@export var master_input:LineEdit
@export var sfx_input:LineEdit
@export var music_input:LineEdit

@export_category("Gameplay")
@export var devconsole_button:Button
@export var devfps_button:Button
@export var tch_tap_button:TextureButton
@export var tch_swipe_button:TextureButton
@export var tch_vbuttons_button:TextureButton
@export var playername_edit:LineEdit
@export var playername_uuid:Label

@export_category("Accesibility")
@export var narrator_button:Button
@export var reduced_motion_button:Button
@export var easier_font_button:Button
@export var easier_font_restart:Label

@export_category("Miscellaneous")
@export var fullscreen_android_info:Label
@export var back_button:Button

func _ready(): # I'm starting to hate this code
	master_slider.value = SettingsBus.volume[SettingsBus.AudioBus.Master]
	sfx_slider.value = SettingsBus.volume[SettingsBus.AudioBus.SFX]
	music_slider.value = SettingsBus.volume[SettingsBus.AudioBus.Music]
	master_input.text = str(master_slider.value * 100) + "%"
	sfx_input.text = str(sfx_slider.value * 100) + "%"
	music_input.text = str(music_slider.value * 100) + "%"
	ui_scaling_slider.value = SettingsBus.ui_scaling
	framerate_cap_input.text = str(SettingsBus.fps_max)
	match(SettingsBus.vsync):
		DisplayServer.VSYNC_DISABLED:
			vsync_button.selected = 0
			framerate_cap_input.editable = true
		DisplayServer.VSYNC_ENABLED:
			vsync_button.selected = 1
		DisplayServer.VSYNC_ADAPTIVE:
			vsync_button.selected = 2
		DisplayServer.VSYNC_MAILBOX:
			vsync_button.selected = 3
			framerate_cap_input.editable = true
	
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
	var playername_split = SettingsBus.playername.split("#")
	playername_edit.text = playername_split[0]
	playername_uuid.text = "#" + playername_split[1]
	easier_font_button.set_pressed_no_signal_custom(SettingsBus.easier_font)
	reduced_motion_button.set_pressed_no_signal_custom(SettingsBus.reduced_motion)
	
	if OS.get_name() != "Android":
		fullscreen_button.set_pressed(SettingsBus.fullscreen)
	else:
		fullscreen_button.disabled = true
		fullscreen_android_info.visible = true
	
	blur_button.set_pressed(SettingsBus.ui_blur)
	
	devconsole_button.set_pressed(SettingsBus.dev_console)
	devfps_button.set_pressed(SettingsBus.dev_show_fps)
	
func _input(event):
	if event.is_action_pressed("next_tab"):
		if $TabContainer.current_tab < 3:
			$TabContainer.current_tab += 1
		elif $TabContainer.current_tab == 3:
			OS.shell_open("https://forms.gle/94hffgvFiSXHfA529")
	elif event.is_action_pressed("previous_tab"):
		if $TabContainer.current_tab > 0:
			$TabContainer.current_tab -= 1


func _on_master_slider_value_changed(value):
	SettingsBus.set_audio_volume(SettingsBus.AudioBus.Master, value)
	master_input.text = str(value * 100) + "%"


func _on_master_slider_drag_ended(_value_changed):
	print(linear_to_db(master_slider.value)*2)


func _on_sfx_slider_value_changed(value):
	SettingsBus.set_audio_volume(SettingsBus.AudioBus.SFX, value)
	sfx_input.text = str(value * 100) + "%"


func _on_sfx_slider_drag_ended(_value_changed):
	$SFXTest.play()
	print(linear_to_db(sfx_slider.value)*2)


func _on_music_slider_value_changed(value):
	SettingsBus.set_audio_volume(SettingsBus.AudioBus.Music, value)
	music_input.text = str(value * 100) + "%"


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


func _on_v_sync_button_item_selected(id: int):
	print(Engine.max_fps)
	framerate_cap_input.editable = false
	Engine.max_fps = 0
	match(id):
		0:
			SettingsBus.vsync = DisplayServer.VSYNC_DISABLED
			framerate_cap_input.editable = true
			Engine.max_fps = SettingsBus.fps_max
		1:
			SettingsBus.vsync = DisplayServer.VSYNC_ENABLED
		2:
			SettingsBus.vsync = DisplayServer.VSYNC_ADAPTIVE
		3:
			SettingsBus.vsync = DisplayServer.VSYNC_MAILBOX
			framerate_cap_input.editable = true
			Engine.max_fps = SettingsBus.fps_max
		_:
			push_error("Unknown entry. V Sync Button is broken. How?")
	SettingsBus.save_override()
	DisplayServer.window_set_vsync_mode(SettingsBus.vsync)


func _on_framelimit_button_text_submitted(new_text):
	SettingsBus.fps_max = int(new_text)
	Engine.max_fps = SettingsBus.fps_max


func _on_ui_blur_button_toggled(toggled_on):
	SettingsBus.set_ui_shader(toggled_on)


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
	SignalBus.enable_touchscreen_vbuttons.emit(true)


func _unpress_tch_buttons():
	tch_tap_button.set_pressed_no_signal(false)
	tch_swipe_button.set_pressed_no_signal(false)
	tch_vbuttons_button.set_pressed_no_signal(false)
	SignalBus.enable_touchscreen_vbuttons.emit(false)


func _on_playername_button_pressed():
	SettingsBus.playername = playername_edit.text.replace("\n", "") + SettingsBus.playername.right(9)


func _on_dev_console_button_toggled(button_pressed):
	SettingsBus.dev_console = button_pressed
	SignalBus.dev_console.emit(button_pressed)


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


func _on_show_console_button_toggled(toggled_on):
	SettingsBus.dev_console = toggled_on
	SignalBus.dev_console.emit(toggled_on)


func _on_show_fps_button_toggled(toggled_on):
	SettingsBus.dev_show_fps = toggled_on
	DebugInfo.toggle_fps()


func _on_back_button_pressed():
	SettingsBus.save_config()
	$"../"._on_back_button_pressed()


func _on_report_bug_pressed(tab):
	if tab == 4:
		OS.shell_open("https://forms.gle/94hffgvFiSXHfA529")
		$TabContainer.current_tab = 0


func _on_info_button_pressed(info):
	var popup = AcceptDialog.new();
	match(info):
		"vsync":
			popup.title = "Synchronizacja pionowa (V-sync)"
			popup.dialog_text = """
Wyłączony - Klatki są renderowane tak szybko jak pozwala na to sprzęt.
Mogą pojawić się rwania obrazu. Umożliwia ustawienie własnego limitu klatek.
Opcja nie działa na urządzeniach z systemem Android.

Włączony - Obraz jest wyświetlany w synchronizacji z częstotliwością odświeżania ekranu.
Klatki są ograniczone do częstotliwości ekranu.
Mogą pojawić się niewielkie opóźnienia obrazu.

Adaptacyjny - Synchronizacja jest włączona, chyba że sprzęt nie będzie w stanie
renderować dostateczenie szybko klatek. Wtedy synchronizacja zostaje wyłączona, aby
ograniczyć ewentualne przycięcia obrazu.
Opcja nie działa na urządzeniach z systemem Android.

Mailbox - Wyświetla najnowszą klatkę w momencie odświeżenia ekranu.
Nie powinien powodować rwania obrazu, a klatki mogą być renderowane tak szybko
jak pozwala na to sprzęt. Umożliwia ustawienie własnego limitu klatek.
"""
		"api":
			popup.title = "API Graficzne"
			popup.dialog_text = """
OpenGL - Starsze API, kompatybilne z większością urządzeń.

Vulkan - Nowsze API, dostępne tylko na nowszych urządzeniach.
Pozwala poprawić jakość grafiki, oraz potencjalnie uzyskać lepszą wydajność.
Może spowodować, że gra się nie uruchomi na urządzeniach, które nie wspierają API Vulkan.
"""
	add_child(popup)
	popup.move_to_center()
	popup.show()


func _on_tab_container_tab_changed(tab):
	match tab:
		0:
			back_button.focus_neighbor_top = ui_scaling_slider.get_path()
		1:
			back_button.focus_neighbor_top = music_slider.get_path()
		2:
			back_button.focus_neighbor_top = devconsole_button.get_path()
		3:
			back_button.focus_neighbor_top = easier_font_button.get_path()
	back_button.grab_focus()


func _on_easier_font_button_toggle(toggled_on):
	pass # Replace with function body.


func _on_tchv_buttons_toggled(toggled_on):
	pass # Replace with function body.
