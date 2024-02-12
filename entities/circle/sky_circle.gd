class_name SkyCircle
extends Node2D

@export var camera : MainCamera
@export var magic_circle : MagicCircle
@export var call_sfx : AudioStream
@export var sfx_dict : Dictionary

const FOLLOW_SPEED = 3.0

var is_circle_activated : bool = false
var is_circle_pathing : bool = false

signal magic_casted(identifier:Globals.MAGIC)

##dictionary of callables that sends signals for use by main level
var book_of_stars : Dictionary = {
	[1,2]:Globals.MAGIC.GROW3,
	[0,1]:Globals.MAGIC.BEARS,
	[0,3]:Globals.MAGIC.DRUIDS2,
	[4,18,20,17,9,8,0,15,14,19]:Globals.MAGIC.GROW1,
	[12,19,6,14,15,0,8,9,2,17,11]:Globals.MAGIC.GROW2,
	[16,19,13,6,14,15,0,8,9,2,10,17,20,18,4]:Globals.MAGIC.GROW3,
	[1, 2, 17, 16, 19, 6, 7]:Globals.MAGIC.SPIKES,
	[20, 17, 16, 19, 12, 18, 11, 4]:Globals.MAGIC.PODS,
	[8, 17, 18, 13, 6, 5, 4, 3, 2, 1, 0]:Globals.MAGIC.BEARS,
	[14, 6, 13, 10, 2, 9, 16, 20]:Globals.MAGIC.HEAL,
	[13, 5, 12, 18, 4, 3, 20, 7, 0, 16, 8, 1, 9]:Globals.MAGIC.DRUIDS1,
	[15,7,14,6,13,5,12,4,11,3,10,2,9,1,8,0,16,17,18,19,20]:Globals.MAGIC.DRUIDS2,
	[15, 14, 19, 20, 17, 16, 18, 11, 10]:Globals.MAGIC.COLLECT,
	[8, 0, 15, 16, 20, 17, 19, 18, 11, 4, 12]:Globals.MAGIC.SPIRIT,
	[8, 9, 1, 20, 16, 19, 18, 17, 10, 11, 12, 13, 14, 15]:Globals.MAGIC.NEEDLES,
	[1,8,0,15,7,14,13,6,19,16,20,18,17,2,9,10,3,11,4,12,5]:Globals.MAGIC.WAVE
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
		call_magic(book_of_stars[stars_logged])
	else:
		var reverse : Array = stars_logged.duplicate()
		reverse.reverse()
		if book_of_stars.has(reverse):
			call_magic(book_of_stars[reverse])

func call_magic(identifier:Globals.MAGIC) -> void:
	magic_circle.extend_sigil()
	SfxManager.play(call_sfx, 0.5)
	if sfx_dict.has(identifier):
		SfxManager.play(sfx_dict[identifier], 0.1)
	magic_casted.emit(identifier)
