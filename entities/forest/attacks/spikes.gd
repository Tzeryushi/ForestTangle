class_name Spikes
extends Node2D

@onready var spike_shape := $SpikeHurtbox/CollisionShape2D

const STARTING_SCALE : Vector2 = Vector2(1.0, 0.01)
const SPEED : float = 0.4
const DAMAGE : float = 20.0

func _ready() -> void:
	scale = STARTING_SCALE

func spawn() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, SPEED).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_callback(disable_hurtbox)
	tween.tween_callback(queue_free)

func disable_hurtbox() -> void:
	spike_shape.disabled = true

func _on_spike_hurtbox_area_entered(area):
	if area is AsteroidHitbox:
		area.take_damage(DAMAGE)
