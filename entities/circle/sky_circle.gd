class_name SkyCircle
extends Node2D

@export var camera : MainCamera
@export var magic_circle : MagicCircle

const FOLLOW_SPEED = 3.0

signal grow_casted
signal attack_casted

##dictionary of callables that sends signals for use by main level
var book_of_stars : Dictionary = {
	[0,1,2,3,4,5,6,7]:grow,
	[7,6,5,4,3,2,1,0]:attack
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.lerp(camera.global_position, delta*FOLLOW_SPEED)
	scale = Vector2.ONE/camera.zoom

func activate_circle() -> void:
	magic_circle.overlap()
	magic_circle.start_pathing()

func deactivate_circle() -> void:
	magic_circle.recede()
	magic_circle.end_pathing()

func _on_magic_circle_stars_logged(stars_logged):
	if book_of_stars.has(stars_logged):
		book_of_stars[stars_logged].call()

func grow() -> void:
	grow_casted.emit()
	print("grow!")

func attack() -> void:
	attack_casted.emit()
	print("attack!")
