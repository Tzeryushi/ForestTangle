class_name Starspace
extends Node2D

@export var camera : Camera2D

var test_sprite : Sprite2D

@onready var unlock_dictionary : Dictionary = {
	Globals.MAGIC.GROW1:$Grow1,
	Globals.MAGIC.GROW2:$Grow2,
	Globals.MAGIC.GROW3:$Grow3,
	Globals.MAGIC.BEARS:$Bears,
	Globals.MAGIC.SPIKES:$Spikes,
	Globals.MAGIC.PODS:$Pods,
	Globals.MAGIC.DRUIDS1:$Druids1,
	Globals.MAGIC.DRUIDS2:$Druids2,
	Globals.MAGIC.HEAL:$Heal,
	Globals.MAGIC.COLLECT:$Collect,
	Globals.MAGIC.NEEDLES:$Needles,
	Globals.MAGIC.SPIRIT:$Spirit,
	Globals.MAGIC.WAVE:$Wave
}

func _ready() -> void:
	for key in unlock_dictionary:
		unlock_dictionary[key].hide()
		unlock_dictionary[key].modulate.a = 0.0

func unlock(key:Globals.MAGIC) -> void:
	if !unlock_dictionary.has(key):
		return
	var constellation = unlock_dictionary[key]
	constellation.show()
	var expose_tween : Tween = create_tween()
	expose_tween.tween_property(constellation, "modulate:a", 1.0, 5.0)

func _process(delta) -> void:
	global_position = global_position.lerp(camera.global_position, delta*1.0)
	scale = Vector2.ONE/camera.zoom
