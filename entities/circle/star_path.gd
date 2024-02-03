class_name StarPath
extends Line2D

var is_pathing : bool = false

func _ready() -> void:
	clear_points()

func _physics_process(_delta) -> void:
	if is_pathing and Input.is_action_pressed("draw"):
		add_point(get_local_mouse_position())

func start_pathing() -> void:
	clear_points()
	is_pathing = true
	pass

func end_pathing() -> void:
	clear_points()
	is_pathing = false
	pass
