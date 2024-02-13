extends Node2D

@export var menu_music : AudioStream
@export var time_last : RichTextLabel
@export var time_best : RichTextLabel
@export var flags : UserFlags

func _ready() -> void:
	MusicManager.play(menu_music)
	time_best.text = "[wave amp=20.0 freq=2.0]Best Time: " + flags.get_best_time_string()
	time_last.text = "[wave amp=20.0 freq=2.0]Your Time: " + flags.get_last_time_string()

func _on_menu_pressed():
	SceneManager.switch_scene("main_menu")
