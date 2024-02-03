class_name MagicCircle
extends Sprite2D

@export var stars : Array[MagicStar]

var star_log : Array[int]

signal stars_logged(stars_logged:Array[int])

func _ready() -> void:
	for star in stars:
		star.path_encountered.connect(log_star)

func start_pathing() -> void:
	star_log.clear()
	for star in stars:
		star.start_pathing()

func end_pathing() -> void:
	for star in stars:
		if star.is_activated:
			star.deactivate()
		star.end_pathing()
	#star_log.clear()

func overlap() -> void:
	modulate.a = 1.0
	z_index = 15

func recede() -> void:
	modulate.a = 0.3
	z_index = 0

func log_star(star_number:int) -> void:
	star_log.append(star_number)
	stars_logged.emit(star_log)
