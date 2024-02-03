extends Node2D

@export var camera : MainCamera
@export var asteroid_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		spawn_asteroid()

func spawn_asteroid() -> void:
	var spawn_rect : Rect2 = camera.get_spawnable_area()
	var spawn_x : float = randf_range(spawn_rect.position.x, spawn_rect.end.x)
	var spawn_y : float = randf_range(spawn_rect.position.y, spawn_rect.end.y)
	var spawn_coords : Vector2 = Vector2(spawn_x, spawn_y)
	var direction = (get_destination() - spawn_coords).normalized()
	
	var asteroid : Asteroid = asteroid_scene.instantiate()
	asteroid = asteroid as Asteroid
	asteroid.global_position = spawn_coords
	asteroid.spawn(direction, 3.0)
	add_child(asteroid)

func get_destination() -> Vector2:
	var x_point : float = randf_range(0.0, get_viewport_rect().size.x)
	return Vector2(x_point, get_viewport_rect().size.y)
