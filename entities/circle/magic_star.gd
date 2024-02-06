class_name MagicStar
extends Node2D

##magic star will send out a signal when it encounters a path that is close to it
##it will grow larger and shine in this event, and will cease doing so on command
@export_range(0, 20) var star_number : int = 0 
@export var star_sprite : Sprite2D
@export var star_sprite_group : StarSpriteGroup
@export var shine_sfx : AudioStream

@onready var spin_speed = randf_range(-0.5,0.5)

const SMALL_STAR_SCALE = Vector2(0.5, 0.5)
const MED_STAR_SCALE = Vector2(0.75, 0.75)
const LARGE_STAR_SCALE = Vector2(1.45, 1.45)

var is_activated : bool = false
var is_pathing : bool = false

signal path_encountered(number:int)

func _ready() -> void:
	star_sprite.scale = SMALL_STAR_SCALE

func _physics_process(_delta) -> void:
	if is_activated:
		star_sprite.rotation += 0.1
	else:
		star_sprite.rotation += spin_speed*0.1

##activate grows the star and spins it faster
func activate() -> void:
	is_activated = true
	SfxManager.play(shine_sfx, 0.05)
	star_sprite_group.set_glow(true)
	star_sprite.scale = LARGE_STAR_SCALE
	path_encountered.emit(star_number)
	pass

func deactivate() -> void:
	is_activated = false
	star_sprite_group.set_glow(false)
	pass

func grow_visible() -> void:
	star_sprite.scale = MED_STAR_SCALE

func shrink_visible() -> void:
	star_sprite.scale = SMALL_STAR_SCALE

func start_pathing() -> void:
	star_sprite.scale = Vector2.ONE
	is_pathing = true

func end_pathing() -> void:
	is_pathing = false
	star_sprite.scale = MED_STAR_SCALE

func _on_collection_area_mouse_entered():
	#if pathing active, activate
	if is_pathing and !is_activated:
		activate()
