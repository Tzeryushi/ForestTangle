class_name FadeTransition
extends CanvasLayer

@onready var screen := $Control/ColorRect
signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func fadein() -> void:
	show()
	screen.modulate.a = 0.0
	var tween : Tween = create_tween()
	tween.tween_property(screen, "modulate:a", 1.0, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	finished.emit()
	hide()

func fadeout() -> void:
	show()
	screen.modulate.a = 1.0
	var tween : Tween = create_tween()
	tween.tween_property(screen, "modulate:a", 0.0, 0.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	finished.emit()
	hide()
