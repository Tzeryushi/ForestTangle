class_name Skyman
extends Node2D


@export var hit_color : Color
@export var death_sfx : AudioStream

signal defeated

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_health_took_damage(_damage):
	var tween : Tween = create_tween()
	tween.tween_property(self, "modulate", hit_color, 0.1)
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.1)
	tween.tween_property(self, "modulate", hit_color, 0.1)
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.1)
	modulate = Color(1,1,1,1)


func _on_health_health_depleted():
	SfxManager.play(death_sfx,0.7)
	var tween : Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 2.0)
	defeated.emit()
