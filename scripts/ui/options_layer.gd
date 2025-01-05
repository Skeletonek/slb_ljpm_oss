extends CanvasLayer

@export_category("Graphics")
@export var fullscreen_button: Button
@export var fullscreen_android_info: Label
@export var graphics_api_button: OptionButton
@export var graphics_api_restart: Label
@export var vsync_button: OptionButton
@export var vsync_info: Label
@export var linux_windowing_system_button: OptionButton
@export var linux_windowing_system_restart: Label
@export var linux_windowing_system_info: Label
@export var framerate_cap_spinbox: SpinBox
@export var blur_button: Button
@export var ui_scaling_slider: HSlider

@export_category("Audio")
@export var master_slider: HSlider
@export var sfx_slider: HSlider
@export var music_slider: HSlider
@export var master_input: LineEdit
@export var sfx_input: LineEdit
@export var music_input: LineEdit

@export_category("Gameplay")
@export var tch_tap_button: TextureButton
@export var tch_swipe_button: TextureButton
@export var tch_vbuttons_button: TextureButton
@export var gamepad_deadzone_slider: Slider
@export var playername_edit: LineEdit
@export var playername_uuid: Label
@export var telemetry_button: Button
@export var touchscreen_mode: Button
@export var touchscreen_mode_android_info: Label
@export var devconsole_button: Button
@export var devfps_button: Button

@export_category("Accesibility")
@export var narrator_button: Button
@export var reduced_motion_button: Button
@export var easier_font_button: Button

@export_category("Technical help")
@export var game_version_label: Label
@export var device_data_label: Label
@export var report_bug_forms_button: Button
@export var report_bug_email_button: Button

@export_category("Miscellaneous")
@export var back_button: Button

@export_category("PopupInfo")
@export var info_popup: CanvasLayer
@export var info_popup_title: Label
@export var info_popup_content: RichTextLabel
@export var info_popup_button: Button

@onready var tab_container := $TabContainer

func _ready(): # I'm starting to hate this code
	master_slider.value = SettingsBus.volume[SettingsBus.AudioBus.MASTER]
	sfx_slider.value = SettingsBus.volume[SettingsBus.AudioBus.SFX]
	music_slider.value = SettingsBus.volume[SettingsBus.AudioBus.MUSIC]
	master_input.text = str(master_slider.value * 100) + "%"
	sfx_input.text = str(sfx_slider.value * 100) + "%"
	music_input.text = str(music_slider.value * 100) + "%"
	ui_scaling_slider.value = SettingsBus.ui_scaling
	framerate_cap_spinbox.value = SettingsBus.fps_max
	gamepad_deadzone_slider.value = SettingsBus.gamepad_deadzone

	_init_vsync_settings()
	_init_tab_names()

	graphics_api_button.get_popup().id_pressed.connect(_on_graphics_api_pressed)
	if SettingsBus.cfg_rendering_method == "gl_compatibility":
		graphics_api_button.selected = 1

	playername_edit.text = ProfileBus.profile.playername
	playername_uuid.text = "#" + ProfileBus.profile.machineid

	match(SettingsBus.touchscreen_control):
		SettingsBus.TouchscreenControlMode.TAP:
			tch_tap_button.set_pressed_no_signal(true)
		SettingsBus.TouchscreenControlMode.SWIPE:
			tch_swipe_button.set_pressed_no_signal(true)
		SettingsBus.TouchscreenControlMode.VBUTTONS:
			tch_vbuttons_button.set_pressed_no_signal(true)

	SignalBus.enable_telemetry.connect(func(x): telemetry_button.set_pressed_no_signal_custom(x))
	telemetry_button.set_pressed_no_signal_custom(SettingsBus.telemetry)
	easier_font_button.set_pressed_no_signal_custom(SettingsBus.easier_font)
	reduced_motion_button.set_pressed_no_signal_custom(SettingsBus.reduced_motion)
	blur_button.set_pressed(SettingsBus.ui_blur)
	touchscreen_mode.set_pressed(SettingsBus.touchscreen_mode)
	devconsole_button.set_pressed(SettingsBus.dev_console)
	devfps_button.set_pressed(SettingsBus.dev_show_fps)

	if OS.get_name() == "Android":
		fullscreen_button.disabled = true
		fullscreen_android_info.visible = true
		touchscreen_mode.disabled = true
		touchscreen_mode_android_info.visible = true
	else:
		fullscreen_button.set_pressed(SettingsBus.fullscreen)

	if OS.get_name() != "Linux":
		linux_windowing_system_info.show()
		linux_windowing_system_button.disabled = true
	match(SettingsBus.cfg_linux_window_system):
		"x11":
			linux_windowing_system_button.selected = 0
		"wayland":
			linux_windowing_system_button.selected = 1

	game_version_label.text = "Wersja gry: " + \
		ProjectSettings.get_setting("application/config/version")
	device_data_label.text = DebugInfo.debug_info()


func _init_vsync_settings():
	var i = 0
	for v in SettingsBus.vsync_availability:
		vsync_button.set_item_disabled(i, !v)
		if v == false:
			vsync_info.show()
		i += 1
	match(DisplayServer.window_get_vsync_mode()):
		DisplayServer.VSYNC_DISABLED:
			vsync_button.selected = 0
			framerate_cap_spinbox.editable = true
		DisplayServer.VSYNC_ENABLED:
			vsync_button.selected = 1
		DisplayServer.VSYNC_ADAPTIVE:
			vsync_button.selected = 2
		DisplayServer.VSYNC_MAILBOX:
			vsync_button.selected = 3
			framerate_cap_spinbox.editable = true


func _init_tab_names():
	tab_container.set_tab_title(0, "Grafika")
	tab_container.set_tab_title(1, "Audio")
	tab_container.set_tab_title(2, "Rozgrywka")
	tab_container.set_tab_title(3, "Dostępność")
	tab_container.set_tab_title(4, "Pomoc techniczna")


func _input(event):
	if event.is_action_pressed("next_tab"):
		if $TabContainer.current_tab < 4:
			$TabContainer.current_tab += 1
		# elif $TabContainer.current_tab == 3:
		# 	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
		# 	OS.shell_open("https://forms.gle/94hffgvFiSXHfA529")
	elif event.is_action_pressed("previous_tab"):
		if $TabContainer.current_tab > 0:
			$TabContainer.current_tab -= 1


func _on_master_slider_value_changed(value):
	SettingsBus.set_audio_volume(SettingsBus.AudioBus.MASTER, value)
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
	SettingsBus.set_audio_volume(SettingsBus.AudioBus.MUSIC, value)
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
	print("FPSCap: " + str(Engine.max_fps))
	framerate_cap_spinbox.editable = false
	Engine.max_fps = 0
	match(id):
		0:
			SettingsBus.vsync = DisplayServer.VSYNC_DISABLED
			framerate_cap_spinbox.editable = true
			Engine.max_fps = SettingsBus.fps_max
		1:
			SettingsBus.vsync = DisplayServer.VSYNC_ENABLED
		2:
			SettingsBus.vsync = DisplayServer.VSYNC_ADAPTIVE
		3:
			SettingsBus.vsync = DisplayServer.VSYNC_MAILBOX
			framerate_cap_spinbox.editable = true
			Engine.max_fps = SettingsBus.fps_max
		_:
			push_error("Unknown entry. V Sync Button is broken. How?")
	SettingsBus.save_override()
	DisplayServer.window_set_vsync_mode(SettingsBus.vsync)


func _on_linux_windowing_system_button_item_selected(id: int):
	match(id):
		0:
			SettingsBus.cfg_linux_window_system = "x11"
		1:
			SettingsBus.cfg_linux_window_system = "wayland"
		_:
			push_error("Unknown entry. Linux Windowing System Button is broken. How?")
	SettingsBus.save_override()
	linux_windowing_system_restart.show()


func _on_framelimit_button_value_changed(value):
	SettingsBus.fps_max = value
	Engine.max_fps = SettingsBus.fps_max


func _on_ui_blur_button_toggled(toggled_on):
	SettingsBus.set_ui_shader(toggled_on)


func _on_ui_scaling_slider_value_changed(value):
	SettingsBus.ui_scaling = value
	get_tree().root.content_scale_factor = value
	SignalBus.reload_scale_factor.emit()


func _on_tch_tap_toggled(_button_pressed):
	_unpress_tch_buttons()
	SettingsBus.touchscreen_control = SettingsBus.TouchscreenControlMode.TAP
	tch_tap_button.set_pressed_no_signal(true)


func _on_tch_swipe_toggled(_button_pressed):
	_unpress_tch_buttons()
	SettingsBus.touchscreen_control = SettingsBus.TouchscreenControlMode.SWIPE
	tch_swipe_button.set_pressed_no_signal(true)


func _on_tch_vbuttons_toggled(_button_pressed):
	_unpress_tch_buttons()
	SettingsBus.touchscreen_control = SettingsBus.TouchscreenControlMode.VBUTTONS
	tch_vbuttons_button.set_pressed_no_signal(true)
	SignalBus.enable_touchscreen_vbuttons.emit(true)


func _unpress_tch_buttons():
	tch_tap_button.set_pressed_no_signal(false)
	tch_swipe_button.set_pressed_no_signal(false)
	tch_vbuttons_button.set_pressed_no_signal(false)
	SignalBus.enable_touchscreen_vbuttons.emit(false)


func _on_deadzone_slider_value_changed(value: float) -> void:
	SettingsBus.gamepad_deadzone = gamepad_deadzone_slider.value


func _on_playername_button_pressed():
	ProfileBus.profile.change_playername(playername_edit.text)


func _on_telemetry_button_toggled(button_preseed):
	SettingsBus.telemetry = button_preseed


func _on_dev_console_button_toggled(button_pressed):
	SettingsBus.dev_console = button_pressed
	SignalBus.dev_console.emit(button_pressed)


func _on_touchscreen_mode_button_toggled(toggled_on):
	SettingsBus.touchscreen_mode = toggled_on
	SignalBus.switch_touchscreen_mode.emit()


func _on_show_console_button_toggled(toggled_on):
	SettingsBus.dev_console = toggled_on
	SignalBus.dev_console.emit(toggled_on)


func _on_show_fps_button_toggled(toggled_on):
	SettingsBus.dev_show_fps = toggled_on
	DebugInfo.toggle_fps()


func _on_reduced_motion_button_toggled(button_pressed):
	SettingsBus.reduced_motion = button_pressed
	SignalBus.reduce_motion.emit(button_pressed)


func _on_easier_font_button_toggled(button_pressed):
	SettingsBus.easier_font = button_pressed
	if button_pressed:
		ThemeDB.get_project_theme().set_default_font(load("res://theme/fonts/OpenDyslexic-Regular.otf"))
	else:
		ThemeDB.get_project_theme().set_default_font(load("res://theme/fonts/PixelifySans_2-Bold.ttf"))


func _on_report_bug_forms_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	OS.shell_open("https://forms.gle/94hffgvFiSXHfA529")


func _on_report_bug_email_button_pressed():
	var version = "Game version: \n" + \
		ProjectSettings.get_setting("application/config/version") + "\n\n"
	var device_data = "Device info:\n" + DebugInfo.debug_info() + "\n"
	var title = "Nie zapomnij wpisać krótkiego tytułu błędu w polu tematu wiadomości e-mail!\n\n"
	var separator = "--------------------------------------------------\n"
	var description = "Opis: \n<Wpisz opis błędu tutaj>\n\n"
	var replication_steps = "Kroki do powtórzenia błędu: \n<Wpisz kroki tutaj>\n\n"
	var body = description + replication_steps + separator + title + version + device_data
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	OS.shell_open("mailto:slb.ljpm@skeletonek.com?body={0}".format([body]))


func _on_import_data_button_pressed():
	if OS.get_name() == "Android":
		OS.request_permissions()
	$OpenFileDialog.set_current_dir(
		OS.get_system_dir(OS.SystemDir.SYSTEM_DIR_DOCUMENTS)
	)
	$OpenFileDialog.set_current_file("slb-ljpm-save-data.zip")
	$OpenFileDialog.popup()


func _on_export_data_button_pressed():
	if OS.get_name() == "Android":
		OS.request_permissions()
	$SaveFileDialog.set_current_dir(
		OS.get_system_dir(OS.SystemDir.SYSTEM_DIR_DOCUMENTS)
	)
	$SaveFileDialog.set_current_file("slb-ljpm-save-data.zip")
	$SaveFileDialog.popup()


func _on_open_file_dialog_file_selected(path):
	var zipper := ZIPReader.new()
	var file
	var err := zipper.open(path)
	if err != OK:
		return PackedByteArray()
	file = FileAccess.open(ProfileBus.FILENAME, FileAccess.WRITE)
	file.store_buffer(zipper.read_file("profile.dat"))
	file.close()
	file = FileAccess.open(AchievementSystem.ACHV_FILE, FileAccess.WRITE)
	file.store_buffer(zipper.read_file("achievements.dat"))
	file.close()
	zipper.close()

	if not AchievementSystem.load_achievements():
		SettingsBus.show_os_alert("ERROR",
			"Achievement file seems to be corrupted. Skipping load"
		)

	var loaded_profile = ProfileBus.load_profile_from_file()
	if loaded_profile:
		ProfileBus.profile = loaded_profile
	else:
		# Whoops!
		SettingsBus.show_os_alert("ERROR",
			"Profile file seems to be corrupted. Skipping load"
		)

	info_popup_title.text = "Wymagane ponowne uruchomienie"
	if OS.get_name() != "Android":
		info_popup_content.text = "Gra zostanie uruchomiona ponownie w celu" \
			+ " poprawnego załadowania zaimportowanych danych gracza"
	else:
		info_popup_content.text = "Gra zostanie teraz wyłączona i będzie wymagać" \
			+ " ręcznego uruchomienia ponownie w celu poprawnego załadowania" \
			+ " zaimportowanych danych gracza"
	info_popup_button.pressed.connect(_restart_due_to_data_load)
	info_popup.show()


func _restart_due_to_data_load():
	if OS.get_name() != "Android":
		OS.create_process(OS.get_executable_path(), [])
	get_tree().quit()


func _on_save_file_dialog_file_selected(path):
	var zipper := ZIPPacker.new()
	var err := zipper.open(path)
	if err != OK:
		return err
	zipper.start_file("profile.dat")
	zipper.write_file(
		FileAccess.get_file_as_bytes(ProfileBus.FILENAME)
	)
	zipper.close_file()
	zipper.start_file("achievements.dat")
	zipper.write_file(
		FileAccess.get_file_as_bytes(AchievementSystem.ACHV_FILE)
	)
	zipper.close_file()
	zipper.close()


func _on_back_button_pressed():
	SettingsBus.save_config()
	# gdlint:ignore=private-method-call
	$"../"._on_back_button_pressed()

# gdlint:disable=max-line-length
func _on_info_button_pressed(info):
	match(info):
		"vsync":
			info_popup_title.text = "Synchronizacja pionowa (V-sync)"
			info_popup_content.text = """
[u]Niektóre opcje mogą nie być dostępne na niektórych systemach[/u]

Wyłączony
[indent]Klatki są renderowane tak szybko jak pozwala na to sprzęt.
Mogą pojawić się rwania obrazu.[/indent]

FIFO - Oszczędność energii
[indent]Obraz jest wyświetlany w synchronizacji z częstotliwością odświeżania ekranu.
Klatki są ograniczone do częstotliwości ekranu i mogą wyświetlać się z opóźnieniem.
Liczba klatek jest dzielona o liczbę całkowitą, jeśli nie można renderować dostatecznie szybko klatek.[/indent]

Adaptacyjny - Minimalizacja przycięć
[indent]Synchronizacja jest włączona, chyba że sprzęt nie będzie w stanie renderować dostateczenie szybko klatek. Wtedy synchronizacja zostaje wyłączona, aby ograniczyć ewentualne przycięcia obrazu.
Najlepszy kompromis na maksymalne ograniczenie przycięć obrazu.
Nieobsługiwane w trybie OpenGL[/indent]

Mailbox - Minimalizacja opóźnienia obrazu
[indent]Renderuje i wyświetla klatkę w momencie odświeżenia obrazu
Gwarantuje niskie opóźnienie obrazu jednocześnie nie powodując jego rwania, ale obraz może nie być renderowany płynnie.
Nieobsługiwane w trybie OpenGL[/indent]
"""
		"api":
			info_popup_title.text = "API Graficzne"
			info_popup_content.text = """
OpenGL
[indent]Starsze API, kompatybilne z większością urządzeń.[/indent]

Vulkan
[indent]Nowsze API, dostępne tylko na nowszych urządzeniach.
Pozwala poprawić jakość grafiki, oraz potencjalnie uzyskać lepszą wydajność.
Może spowodować, że gra się nie uruchomi na urządzeniach, które nie wspierają API Vulkan.[/indent]
"""
		"linux_window_sys":
			info_popup_title.text = "System wyświetlania okien"
			info_popup_content.text = """
[u]Ta opcja działa tylko na systemach Linux[/u]

X11
[indent]Starszy system wyświetlania okien. Kompatybilny z większością urządzeń.[/indent]

Wayland
[indent]Nowszy system wyświetlania okien, wspierany lepiej na nowszych systemach.
Korzystanie z tego systemu może wymusić włączenie synchronizacji pionowej, w zależności od posiadanego kompozytora okien, wersji sterowników graficznych oraz jądra systemu.
Nie zaleca się włączania tej opcji podczas korzystania z sesji X11.
Ta opcja jest eksperymentalna i może powodować problemy.[/indent]
"""
		"telemetry":
			info_popup_title.text = "Telemetria"
			info_popup_content.text = """
Wyłączony
[indent]Gra nie wysyła żadnych danych.[/indent]

Włączony
[indent]Gra okresowo będzie wysyłać statystyki dotyczące Twojego profilu, dla usprawnienia rozgrywki czy usprawnienia globalnych statystyk takich jak procent graczy, które odblokowały dane osiągnięcie. Do wysyłanych statystyk należą:
 - Informacje o zdobytych osiągnięciach
 - Statystyki gry takie jak ilość zdobytych mlek itp.
 - Zakupione skórki w sklepie
 - Wybrane ustawienia
 - Statystyki dotyczące sprzętu
Twoje dane pozostaną anonimowe i pozbawione wszelkich informacji, które pozwoliłyby powiązać je z Twoim profilem.[/indent]
"""
	info_popup.show()
# gdlint:enable=max-line-length

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
		4:
			back_button.focus_neighbor_top = report_bug_email_button.get_path()
	back_button.grab_focus()
	GlobalMusic.button_sound(false, GlobalMusic.BtnType.STANDARD)
