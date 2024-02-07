class_name Asteroid
extends Node2D

@export var asteroid_sprite : Sprite2D
@export var sprites : Array[CompressedTexture2D]
@export var boom_particles : PackedScene
@export var boom_sfx : AudioStream
@export var default_damage : float = 4.0
@export var default_speed : float = 1.2

@onready var rotation_speed = randf_range(-1,1)

var direction : Vector2 = Vector2.ZERO
var speed : float = 0.0
var damage : float = 0.0

signal destructed

func _ready() -> void:
	asteroid_sprite.texture = sprites.pick_random()

func _process(delta) -> void:
	rotation+=rotation_speed*delta

func _physics_process(_delta) -> void:
	global_position = global_position + direction * speed

func spawn(_direction, _speed=default_speed, _damage=default_damage) -> void:
	direction = _direction
	speed = _speed
	damage = _damage

func destruct() -> void:
	SfxManager.play(boom_sfx, 0.1)
	var particles = boom_particles.instantiate()
	particles = particles as BaseParticle
	get_tree().get_first_node_in_group("spawnspace").add_child(particles)
	particles.global_position = global_position
	particles.play()
	destructed.emit()
	queue_free()

func _on_health_health_depleted():
	destruct()

func _on_asteroid_hurtbox_collided():
	destruct()
