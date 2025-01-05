extends Sprite2D

var tween: Tween

func start_blinking() -> void:
    if tween:
        tween.kill()
    tween = create_tween()
    tween.tween_property(
        self,
        "modulate",
        Color.WHITE,
        0,
    )
    tween.tween_interval(0.5)
    tween.tween_property(
        self,
        "modulate",
        Color.BLACK,
        0,
    )
    tween.tween_interval(0.5)
    tween.set_loops()

func stop_blinking() -> void:
    tween.kill()
    modulate = Color.BLACK

func light_on() -> void:
    modulate = Color.WHITE

func light_off() -> void:
    modulate = Color.BLACK
