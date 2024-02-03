class_name MagicStar
extends Node2D

##magic star will send out a signal when it encounters a path that is close to it
##it will grow larger and shine in this event, and will cease doing so on command
@export_range(0, 20) var star_number : int = 0 
@export var star_sprite : Sprite2D

@onready var spin_speed = randf_range(-0.5,0.5)

var is_activated : bool = false
var is_pathing : bool = false

signal path_encountered(number:int)

func _physics_process(_delta) -> void:
	star_sprite.rotation += spin_speed*0.1

##activate grows the star and spins it faster
func activate() -> void:
	is_activated = true
	path_encountered.emit(star_number)
	pass

func deactivate() -> void:
	is_activated = false
	pass

func start_pathing() -> void:
	is_pathing = true

func end_pathing() -> void:
	is_pathing = false

func _on_collection_area_mouse_entered():
	#if pathing active, activate
	if is_pathing and !is_activated:
		print("Pathed!")
		activate()
