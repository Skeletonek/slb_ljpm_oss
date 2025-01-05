extends CanvasLayer

@export var agree_button: Button
@export var disagree_button: Button

func _on_telemetry_agreement() -> void:
	SettingsBus.telemetry = true
	SignalBus.enable_telemetry.emit(true)
	hide()
