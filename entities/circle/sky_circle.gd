class_name SkyCircle
extends Node2D

@export var camera : MainCamera
@export var magic_circle : MagicCircle

const FOLLOW_SPEED = 3.0

var is_circle_activated : bool = false
var is_circle_pathing : bool = false

signal grow_casted
signal attack_spikes_casted
signal attack_pods_casted
signal attack_bears_casted
signal heal_casted
signal make_druid_casted

##dictionary of callables that sends signals for use by main level
var book_of_stars : Dictionary = {
	[0,1]:grow,
	[12,19,6,14,15,0,8,9,2,17,11]:grow,
	[1, 2, 17, 16, 19, 6, 7]:attack_spikes,
	[20, 17, 16, 19, 12, 18, 11, 4]:attack_pods,
	[0, 8, 17, 18, 13, 6, 5, 4, 3, 2, 1]:attack_bears,
	[14, 6, 13, 10, 2, 9, 16, 20]:heal,
	[15, 7, 14, 6, 13, 5, 12, 4, 11, 3, 10, 2, 9, 1, 8, 0, 16, 17, 18, 19, 20]:make_druid
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.lerp(camera.global_position, delta*FOLLOW_SPEED)
	scale = Vector2.ONE/camera.zoom

func _unhandled_input(_event) -> void:
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
		

func _on_magic_circle_stars_logged(stars_logged:Array[int]):
	if book_of_stars.has(stars_logged):
		book_of_stars[stars_logged].call()
	else:
		var reverse : Array = stars_logged.duplicate()
		reverse.reverse()
		if book_of_stars.has(reverse):
			book_of_stars[reverse].call()

func grow() -> void:
	grow_casted.emit()

func attack_spikes() -> void:
	attack_spikes_casted.emit()

func attack_pods() -> void:
	attack_pods_casted.emit()

func attack_bears() -> void:
	attack_bears_casted.emit()

func heal() -> void:
	heal_casted.emit()

func make_druid() -> void:
	make_druid_casted.emit()
