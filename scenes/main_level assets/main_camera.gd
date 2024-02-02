extends Camera2D

@export var move_ratio : float = 0.1

@onready var base_position : Vector2 = position

func _ready() -> void:
	Globals.set_camera(self)

func change_base_position(new_base_position:Vector2) -> void:
	base_position = new_base_position

func _process(delta) -> void:
	position = base_position + get_local_mouse_position()*move_ratio
