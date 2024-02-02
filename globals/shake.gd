extends Node

var decay : float = 1.2
var max_offset : Vector2 = Vector2(100, 75)
var max_roll : float = 0.1
var max_trauma : float = 1.5

@onready var noise : FastNoiseLite = FastNoiseLite.new()
var shake_camera : Camera2D = null
var shake_intensity : float = 0.0
var shake_duration : float = 0.0
var trauma = 0.0  # Current shake strength.
var trauma_power = 2 

func _ready() -> void:
	noise.seed = randi()
	noise.fractal_octaves = 5
	noise.frequency = 0.15

func _process(_delta) -> void:
	if !shake_camera:
		return
	if trauma:
		trauma = max(trauma - decay * _delta, 0)
		shake()

func add_trauma(amount, trauma_max:float = max_trauma):
	var new_trauma = clampf(trauma + amount, 0.0, trauma_max)
	if trauma < new_trauma:
		trauma = new_trauma

func set_camera(camera:Camera2D) -> void:
	shake_camera = camera

func shake() -> void:
	var amount = pow(trauma, trauma_power)
	shake_camera.rotation = max_roll * amount * randf_range(-1, 1)
	shake_camera.offset.x = max_offset.x * amount * randf_range(-1, 1)
	shake_camera.offset.y = max_offset.y * amount * randf_range(-1, 1)
