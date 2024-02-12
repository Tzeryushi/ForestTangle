extends Node2D


const WAVE_SPEED : float = 6.0

var direction : Vector2 = Vector2.UP

func _ready() -> void:
	scale = Vector2(0.0,0.0)
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale:x", 1.0, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(self, "scale:y", 1.0, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _physics_process(_delta) -> void:
	position += WAVE_SPEED * direction

func destruct() -> void:
	queue_free()


func _on_wave_hitbox_area_entered(area):
	if area is AsteroidHitbox:
		area.take_damage(40)

func _on_destruct_timer_timeout():
	destruct()
