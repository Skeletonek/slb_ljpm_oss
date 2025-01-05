extends Control

const ERROR_MSG_PREFIX := "USER ERROR: "
const WARNING_MSG_PREFIX := "USER WARNING: "

@export var DevErrorsLabel: RichTextLabel

func _ready():
	if OS.is_debug_build():
		$DebugInfo/Version.visible = true
		$DebugInfo/DevErrors.visible = true
		$DebugInfo/FPS.visible = true
		$DebugInfo/Version/VersionBuildDate2.text = "Development Version"
	$DebugInfo/Version/VersionBuildDate.text = "SLB: LJPM\n" + \
	"Version: " + ProjectSettings.get_setting("application/config/version") + "\n" + \
	"Build: " + str(ProjectSettings.get_setting("application/config/build_number")) + "\n" + \
	"Date: " + ProjectSettings.get_setting("application/config/date")
	print(debug_info())


func _process(delta):
	$DebugInfo/FPS.text = "FPS: %4d" % (1 / delta)


func toggle():
	$DebugInfo/Version.visible = !$DebugInfo/Version.visible


func toggle_fps():
	$DebugInfo/FPS.visible = SettingsBus.dev_show_fps


func toggle_errors():
	$DebugInfo/DevErrors.visible = SettingsBus.dev_show_errors


func debug_info() -> String:
	var GPUAPI: String
	# This function return null when using OpenGL
	if RenderingServer.get_rendering_device() == null:
		GPUAPI = "OpenGL"
	else:
		GPUAPI = "Vulkan"
	var text = "Godot Engine " + Engine.get_version_info().string + "\n" + \
	"OS: " + OS.get_name() + " " + OS.get_distribution_name() + " " + OS.get_version() + "\n" + \
	"CPU: " + OS.get_processor_name() + " " + str(OS.get_processor_count()) + " threads \n" + \
	"GPU: " + RenderingServer.get_video_adapter_vendor() + " " + RenderingServer.get_video_adapter_name() + "\n" + \
	"GPU API: " + GPUAPI + " " + RenderingServer.get_video_adapter_api_version() + "\n" + \
	"DISPLAY: " + DisplayServer.get_name()
	return text


func append_error(text):
	DevErrorsLabel.append_text("[color=red][ERR] " +
	text.trim_prefix(ERROR_MSG_PREFIX) + "[/color]\n")


func append_warning(text):
	DevErrorsLabel.append_text("[color=orange][WRN] " +
	text.trim_prefix(WARNING_MSG_PREFIX) + "[/color]\n")

