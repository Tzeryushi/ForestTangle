class_name Podmaker
extends Node2D

@export var pod_scene : PackedScene
@export var number_of_pods : float = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func call_pods() -> void:
	for i in range(number_of_pods):
		var tween : Tween = create_tween()
		tween.tween_callback(spawn_pod)
		await get_tree().create_timer(0.5).timeout
	queue_free()

func spawn_pod() -> void:
	var new_pod = pod_scene.instantiate()
	new_pod = new_pod as Seedpod
	get_tree().get_first_node_in_group("spawnspace").add_child(new_pod)
	new_pod.global_position = global_position
	new_pod.spawn()
