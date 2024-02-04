extends Node2D

@export var title_music : AudioStream

func _ready() -> void:
	MusicManager.play(title_music)


func _on_begin_pressed():
	SceneManager.switch_scene("main_level")

func _on_end_pressed():
	SceneManager.quit_game()
