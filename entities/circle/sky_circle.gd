class_name SkyCircle
extends Node2D

@export var camera : MainCamera
@export var magic_circle : MagicCircle

const FOLLOW_SPEED = 3.0

var is_circle_activated : bool = false
var is_circle_pathing : bool = false

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

func _unhandled_input(event) -> void:
	if is_circle_activated :
		if Input.is_action_just_pressed("draw") and !is_circle_pathing:
			magic_circle.start_pathing()
			is_circle_pathing = true
		elif Input.is_action_just_released("draw") and is_circle_pathing:
			magic_circle.end_pathing()
			is_circle_pathing = false

func activate_circle() -> void:
	magic_circle.overlap()
	is_circle_activated = true
	if Input.is_action_pressed("draw"):
		magic_circle.start_pathing()
		is_circle_pathing = true

func deactivate_circle() -> void:
	if is_circle_pathing:
		magic_circle.end_pathing()
		is_circle_pathing = false
	magic_circle.recede()
	is_circle_activated = false
		

func _on_magic_circle_stars_logged(stars_logged):
	if book_of_stars.has(stars_logged):
		book_of_stars[stars_logged].call()

func grow() -> void:
	grow_casted.emit()
	print("grow!")

func attack() -> void:
	attack_casted.emit()
	print("attack!")
