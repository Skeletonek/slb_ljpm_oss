extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.is_debug_build():
		$DebugInfo.visible = true
	$DebugInfo/VersionBuildDate.text = "SLB: LJPM\n" + \
	"Version: " + ProjectSettings.get_setting("application/config/version") + "\n" + \
	"Build: " + str(ProjectSettings.get_setting("application/config/build_number")) + "\n" + \
	"Date: " + ProjectSettings.get_setting("application/config/date")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func toggle():
	$DebugInfo.visible = !$DebugInfo.visible
