extends Node2D

const NEEDLE_SPEED : float = 8.0

var direction : Vector2 = Vector2(0,-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2.ZERO
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)

func _physics_process(_delta) -> void:
	position += direction * NEEDLE_SPEED

func destruct() -> void:
	queue_free()

func _on_needler_thorns_hurtbox_area_entered(area):
	if area is AsteroidHitbox:
		area.take_damage(40)

func _on_death_timer_timeout():
	destruct()
