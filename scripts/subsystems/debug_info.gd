extends Control

const ERROR_MSG_PREFIX_1 := "ERROR: "
const ERROR_MSG_PREFIX_2 := "USER ERROR: "
const ERROR_MSG_PREFIX_3 := "USER SCRIPT ERROR: "
const WARNING_MSG_PREFIX_1 := "WARNING: "
const WARNING_MSG_PREFIX_2 := "USER WARNING: "

@export var fps_label: Label
@export var delta_label: Label

@export var dev_errors_label: RichTextLabel
@export var dev_errors_cleaner: Timer

func _ready():
	if OS.is_debug_build():
		$DebugInfo/Version.visible = true
		dev_errors_label.visible = true
		fps_label.visible = true
		delta_label.visible = true
		$DebugInfo/Version/VersionBuildDate2.text = "Development Version"
	$DebugInfo/Version/VersionBuildDate.text = "SLB: LJPM\n" + \
	"Build: " + str(ProjectSettings.get_setting("application/config/build_number")) + "\n" + \
	"Version: " + ProjectSettings.get_setting("application/config/version") + "\n" + \
	"Date: " + ProjectSettings.get_setting("application/config/date")
	print(debug_info())


func _process(delta):
	if SettingsBus.dev_show_fps:
		var fps = Engine.get_frames_per_second()
		fps_label.text = "FPS: %4d" % fps
		delta_label.text = "Delta: %.5f" % delta
		fps_label.label_settings.font_color = _label_color(30, 60, fps)
		delta_label.label_settings.font_color = _label_color(-0.03334, 	-0.01667, -delta)


func _label_color(lowest, low, value) -> Color:
	if value < lowest:
		return Color.RED
	if lowest <= value and value < low:
		return Color.ORANGE
	return Color.WHITE


func toggle():
	$DebugInfo/Version.visible = !$DebugInfo/Version.visible


func toggle_fps():
	fps_label.visible = SettingsBus.dev_show_fps
	delta_label.visible = SettingsBus.dev_show_fps


func toggle_errors():
	dev_errors_label.visible = SettingsBus.dev_show_errors


func debug_info() -> String:
	var godot_version = Engine.get_version_info().string
	var os_name = OS.get_name()
	var os_distroname = OS.get_distribution_name()
	var os_version = OS.get_version()
	var device_name = OS.get_model_name()
	var locale = OS.get_locale_language()
	var cpu_name = OS.get_processor_name()
	var cpu_corecount = str(OS.get_processor_count())
	var mem_physical = OS.get_memory_info()['physical'] / 1048576
	var mem_free = OS.get_memory_info()['free'] / 1048576
	var mem_available = OS.get_memory_info()['available'] / 1048576
	var mem_stack = OS.get_memory_info()['stack'] / 1048576
	var gpu_vendor = RenderingServer.get_video_adapter_vendor()
	var gpu_name = RenderingServer.get_video_adapter_name()
	# RenderingServer.get_rendering_device returns null when using OpenGL
	var gpuapi = ("OpenGL"
			if RenderingServer.get_rendering_device() == null
			else "Vulkan"
	)
	var gpuapi_version = RenderingServer.get_video_adapter_api_version()
	var displayserver = DisplayServer.get_name()

	return (
		"Godot Engine {0}\n" +
		"OS: {1} {2} {3}\n" +
		"DEVICE: {16}\n" +
		"CPU: {4} {5} threads\n" +
		"MEMORY: ALL:{12}M | FREE:{13}M | AVAIL:{14}M | STACK:{15}M\n"+
		"GPU: {6} {7}\n" +
		"GPU API: {8} {9}\n" +
		"DISPLAY: {10}\n" +
		"LANG: {11}"
	).format([
		godot_version,
		os_name,
		os_distroname,
		os_version,
		cpu_name,
		cpu_corecount,
		gpu_vendor,
		gpu_name,
		gpuapi,
		gpuapi_version,
		displayserver,
		locale,
		mem_physical,
		mem_free,
		mem_available,
		mem_stack,
		device_name,
	])


func append_error(text):
	dev_errors_label.append_text("[color=red][ERR] " + \
			text.trim_prefix(
				ERROR_MSG_PREFIX_1
			).trim_prefix(
				ERROR_MSG_PREFIX_2
			).trim_prefix(
				ERROR_MSG_PREFIX_3
			) + "[/color]\n"
	)
	dev_errors_cleaner.wait_time = 10.0
	dev_errors_cleaner.start()


func append_warning(text):
	dev_errors_label.append_text("[color=orange][WRN] " +
			text.trim_prefix(
				WARNING_MSG_PREFIX_1
			).trim_prefix(
				WARNING_MSG_PREFIX_2
			) + "[/color]\n"
	)
	dev_errors_cleaner.wait_time = 10.0
	dev_errors_cleaner.start()


func _on_dev_errors_cleaner_timeout():
	dev_errors_label.text = ""
