extends Node

enum MAGIC {GROW1=0, SPIKES=1, COLLECT=2, PODS=3, BEARS=4, HEAL=5, GROW2=6, GROW3=7, DRUIDS1=8, DRUIDS2=9}


var camera : MainCamera

func set_camera(new_camera:MainCamera) -> void:
	camera = new_camera
func get_camera() -> MainCamera:
	return camera
