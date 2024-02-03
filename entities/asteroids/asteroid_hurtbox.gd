class_name AsteroidHurtbox
extends Area2D

@export var asteroid : Asteroid

signal collided

func _on_area_entered(area):
	if area is ForestHitbox:
		area.take_damage(asteroid.damage)
	collided.emit()
