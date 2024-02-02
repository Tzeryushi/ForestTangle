extends Node

var camera : Camera2D

func set_camera(new_camera:Camera2D) -> void:
	camera = new_camera
func get_camera() -> Camera2D:
	return camera
