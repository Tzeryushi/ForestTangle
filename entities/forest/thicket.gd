class_name Thicket
extends Node2D

@export var is_base_thicket : bool = false
@export var health : Health
@export var thicket_height : float = 90.0

var last_thicket : Thicket = null
var next_thicket : Thicket = null

signal destructed(thicket_node:Thicket, last_thicket:Thicket)

func _ready() -> void:
	assert(health != null, "Health not set on " + str(self))

##moves a new thicket into place with an animation
func pop_up() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self,"position", position-Vector2(0,thicket_height), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func destruct() -> void:
	#thicket dies and must crawl through chain to delete others before deleting itself
	if next_thicket != null:
		next_thicket.destruct()
		await next_thicket.destructed
	destructed.emit(self, last_thicket)
	queue_free()

func _on_health_health_depleted():
	destruct()
