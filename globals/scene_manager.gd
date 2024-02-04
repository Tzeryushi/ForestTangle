extends Node

@export var scenes : Dictionary = {}
@export var transition_scene : PackedScene

var current_scene_name : String = ""


func _ready() -> void:
	var main_scene : String = ProjectSettings.get_setting("application/run/main_scene")
	current_scene_name = scenes.find_key(main_scene)

func add_scene(scene_name:String, scene_path:String) -> void:
	scenes[scene_name] = scene_path

func remove_scene(scene_name:String) -> void:
	scenes.erase(scene_name)

func switch_scene(scene_name:String) -> void:
	var transition = transition_scene.instantiate()
	transition = transition as FadeTransition
	get_tree().root.add_child(transition)
	transition.fadein()
	await transition.finished
	get_tree().change_scene_to_file(scenes[scene_name])
	transition = transition_scene.instantiate()
	get_tree().root.add_child(transition)
	transition.fadeout()
	await transition.finished
	transition.queue_free()

func restart_scene() -> void:
	get_tree().reload_current_scene()

func quit_game() -> void:
	get_tree().quit()
