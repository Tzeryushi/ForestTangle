extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(0,0)
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.3,1.3), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free)

func _on_roar_area_area_entered(area):
	if area is AsteroidHitbox:
		area.take_damage(20)
