class_name Health
extends Node

@export var max_health : float = 10
@export var has_different_starting_health : bool = false
@export var starting_health : float = 10

@onready var health : float = max_health

signal took_damage(damage:float)
signal gained_life(life:float)
signal health_changed(new_health:float)
signal health_depleted()

func _ready() -> void:
	if has_different_starting_health:
		health = clampf(has_different_starting_health, 0.0, max_health)
	else:
		health = max_health

func take_damage(value:float) -> void:
	var old_health = health
	health = clampf(health-value, 0.0, max_health)
	took_damage.emit(value)
	health_changed.emit(health)
	if old_health-value <= 0.0:
		health_depleted.emit()

func heal(value:float) -> void:
	var old_health = health
	health = clampf(health+value, 0.0, max_health)
	gained_life.emit(value)
	health_changed.emit(health)
	if old_health+value <= 0.0:
		health_depleted.emit()

func set_health(new_value:float) -> void:
	var old_health = health
	health = clampf(new_value, 0.0, max_health)
	if old_health > health:
		took_damage.emit(old_health-health)
	elif old_health < health:
		gained_life.emit(health-old_health)
	health_changed.emit(health)
	if health <= 0.0:
		health_depleted.emit()

func get_health() -> float:
	return health
