extends Node2D

@export var title_music : AudioStream

func _ready() -> void:
	MusicManager.play(title_music)

func _process(delta):
	pass
