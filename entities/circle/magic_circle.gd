class_name MagicCircle
extends Sprite2D

@export var stars : Array[MagicStar]
@export var star_path : StarPath

var star_log : Array[int]

signal stars_logged(stars_logged:Array[int])

func _ready() -> void:
	for star in stars:
		star.path_encountered.connect(log_star)

func start_pathing() -> void:
	star_log.clear()
	for star in stars:
		star.start_pathing()
	star_path.start_pathing()
	
	#check if mouse starts inside a star
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.collide_with_areas = true
	params.collision_mask = 0b10000
	params.position = get_global_mouse_position()
	var out = space_state.intersect_point(params)
	if out.size() > 0 and out[0].collider is CollisionObject2D:
		out[0].collider.mouse_entered.emit()

func end_pathing() -> void:
	for star in stars:
		if star.is_activated:
			star.deactivate()
		star.end_pathing()
	#star_log.clear()
	star_path.end_pathing()

func extend_sigil() -> void:
	star_path.make_end_copy()

func overlap() -> void:
	modulate.a = 1.0
	z_index = 15
	for star in stars:
		star.grow_visible()

func recede() -> void:
	modulate.a = 0.3
	z_index = -14
	for star in stars:
		star.shrink_visible()

func log_star(star_number:int) -> void:
	star_log.append(star_number)
	print(star_log)
	stars_logged.emit(star_log)
