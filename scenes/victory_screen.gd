extends Node2D

@export var menu_music : AudioStream

func _ready() -> void:
	MusicManager.play(menu_music)

func _on_menu_pressed():
	SceneManager.switch_scene("main_menu")
