class_name SkyHitbox
extends Area2D

@export var health : Health

@onready var hit_shape := $HitShape

signal skyman_hit(damage:float)

func _ready() -> void:
	assert(health != null, "Health not set on " + str(self))

func take_damage(damage_value:float) -> void:
	skyman_hit.emit()
	health.take_damage(damage_value)
