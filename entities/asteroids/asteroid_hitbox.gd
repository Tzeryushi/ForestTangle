class_name AsteroidHitbox
extends Area2D

@export var health : Health

signal hit(damage:float)

func _ready() -> void:
	assert(health != null, "Health not set on " + str(self))

func take_damage(damage_value:float) -> void:
	health.take_damage(damage_value)
