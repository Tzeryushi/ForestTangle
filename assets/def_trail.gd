class_name DefTrail
extends Line2D

@export var trail_length : int = 200

func _ready():
	pass # Replace with function body.

func _physics_process(_delta) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	var point : Vector2 = get_parent().global_position
	add_point(point)
	while get_point_count() > trail_length:
		remove_point(0)
