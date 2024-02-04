class_name Forest
extends Node2D

#forests are comprised of thickets, each of which have hitboxes
#thickets handle themselves, containing references to thickets before and after
#when a thicket is destroyed, it traces any thickets on top of it and destroys them too
#forests themselves handle the casting of spells and adding new thickets
#if a forest has no thickets, it triggers a signal

signal forest_lost(lost_forest:Forest)
signal forest_grown(position:Vector2)
signal forest_receded(position:Vector2)

@export var base_thicket : Thicket
@export var thicket_scene : PackedScene
@export var spike_scene : PackedScene
@export var pod_scene : PackedScene
@export var heal_sfx : AudioStream
@export var selector : Sprite2D
@export var forest_call : String = "forest1"

@onready var top_thicket : Thicket = base_thicket
@onready var thicket_array : Array[Thicket] = [base_thicket]

var is_activated : bool = false

#func _unhandled_input(event) -> void:
	#if is_activated:
		#if Input.is_action_just_pressed("ui_up"):
			#grow_thicket()

##activates forest for drawing
func activate() -> void:
	is_activated = true
	if top_thicket:
		selector.position = top_thicket.position + Vector2(0, -100)
	else:
		selector.position = Vector2(0, -100)
	selector.show()

func deactivate() -> void:
	is_activated = false
	selector.hide()

##immediately grows a new thicket
func grow_thicket() -> void:
	#should instance new thicket, connect it to the last thicket
	var new_thicket : Thicket = thicket_scene.instantiate()
	new_thicket = new_thicket as Thicket
	
	if base_thicket == null:
		base_thicket = new_thicket
		new_thicket.position = Vector2.ZERO
	else:
		new_thicket.position = top_thicket.position
		top_thicket.next_thicket = new_thicket
		new_thicket.last_thicket = top_thicket
	thicket_array.append(new_thicket)
	top_thicket = new_thicket
	new_thicket.destructed.connect(_on_thicket_destructed)
	add_child(new_thicket)
	move_child(new_thicket, 0)
	if base_thicket == new_thicket:
		new_thicket.position = new_thicket.position + Vector2(0.0, new_thicket.thicket_height)
	forest_grown.emit(Vector2(new_thicket.position.x, new_thicket.position.y-new_thicket.thicket_height))
	new_thicket.pop_up()
	pass

##heal all thickets in the forest
func heal_thickets(heal_amount:float) -> void:
	SfxManager.play(heal_sfx,0.7)
	for thicket in thicket_array:
		for child in thicket.get_children():
			if child is Health:
				child.heal(heal_amount)

##prompts the top thicket to grow upwards and destroy asteroids above it
func attack_spikes() -> void:
	var new_spikes = spike_scene.instantiate()
	new_spikes = new_spikes as Spikes
	get_tree().get_first_node_in_group("spawnspace").add_child(new_spikes)
	new_spikes.global_position = top_thicket.global_position
	new_spikes.spawn()

func attack_pods() -> void:
	var new_podmaker = pod_scene.instantiate()
	new_podmaker = new_podmaker as Podmaker
	new_podmaker.position = top_thicket.position
	add_child(new_podmaker)
	new_podmaker.call_pods()

func attack_bears() -> void:
	print("make bears!")
	pass

##spawns a new druid at top thicket
func make_druid() -> void:
	print("make a druid here!")
	pass

func get_top_location() -> Vector2:
	if top_thicket == null:
		return Vector2.ZERO
	return top_thicket.position

func get_stack_size() -> int:
	return thicket_array.size()

func _on_thicket_destructed(thicket_node:Thicket, last_thicket:Thicket):
	thicket_array.erase(thicket_node)
	if thicket_node == base_thicket:
		forest_lost.emit()
		print("Forest Lost!")
		base_thicket = null
		top_thicket = null
	elif last_thicket != null:
		top_thicket = last_thicket
		forest_receded.emit(top_thicket.position)
