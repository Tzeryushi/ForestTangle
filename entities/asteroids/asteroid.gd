class_name Asteroid
extends Node2D

@export var default_damage : float = 4.0
@export var default_speed : float = 1.0

var direction : Vector2 = Vector2.ZERO
var speed : float = 0.0
var damage : float = 0.0

func _physics_process(_delta) -> void:
	global_position = global_position + direction * speed

func spawn(_direction, _speed=default_speed, _damage=default_damage) -> void:
	direction = _direction
	speed = _speed
	damage = _damage

func destruct() -> void:
	queue_free()

func _on_health_health_depleted():
	destruct()
