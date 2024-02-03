extends Node

var camera : MainCamera

func set_camera(new_camera:MainCamera) -> void:
	camera = new_camera
func get_camera() -> MainCamera:
	return camera
