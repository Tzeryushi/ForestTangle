class_name MainCamera
extends Camera2D

@export var move_ratio : float = 0.1

@onready var base_position : Vector2 = position

func _ready() -> void:
	Globals.set_camera(self)
	
func _process(delta) -> void:
	position = base_position + get_local_mouse_position()*move_ratio
	
func change_base_position(new_base_position:Vector2) -> void:
	base_position = new_base_position

func get_spawnable_area() -> Rect2:
	var push_size = get_viewport_rect().size * 0.5 + Vector2(0, 150)
	return Rect2(global_position-push_size-Vector2(0,50), Vector2(get_viewport_rect().size.x, 50))
