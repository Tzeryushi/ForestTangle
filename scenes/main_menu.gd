extends Node2D

@export var title_music : AudioStream

func _ready() -> void:
	MusicManager.play(title_music)
	await get_tree().create_timer(4.0).timeout
	SceneManager.switch_scene("main_level")
