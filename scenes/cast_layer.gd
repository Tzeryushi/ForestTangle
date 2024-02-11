class_name CastLayer
extends Control

@export var star_text : RichTextLabel
@export var fade_time : float = 0.2

var fade_tween : Tween

signal finished

func play_text(line_text:String, time:float=1.0) -> void:
	if fade_tween:
		fade_tween.kill()
	show()
	star_text.modulate.a = 0.0
	star_text.text = "[center][wave amp=30.0 freq=5.0]⚝ " + line_text.to_upper() + " ⚝"
	fade_tween = create_tween()
	fade_tween.tween_property(star_text, "modulate:a", 1.0, fade_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await fade_tween.finished
	await get_tree().create_timer(time).timeout
	fade_tween = create_tween()
	fade_tween.tween_property(star_text, "modulate:a", 0.0, fade_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await fade_tween.finished
	hide()
	finished.emit()
