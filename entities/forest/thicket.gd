class_name Thicket
extends Node2D

@export var is_base_thicket : bool = false
@export var health : Health

#var last_thicket : Thicket = null
var next_thicket : Thicket = null

signal destructed(thicket_node:Thicket)

func _ready() -> void:
	assert(health != null, "Health not set on " + str(self))

func destruct() -> void:
	#thicket dies and must crawl through chain to delete others before deleting itself
	if next_thicket != null:
		next_thicket.destruct()
		await next_thicket.destructed
	destructed.emit(self)
	queue_free()

func _on_health_health_depleted():
	destruct()
