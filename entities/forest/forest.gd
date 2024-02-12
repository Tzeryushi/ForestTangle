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
signal druid_made(druid_ref:Druid)
signal not_enough_druids

@export var base_thicket : Thicket
@export var thicket_scene : PackedScene
@export var spike_scene : PackedScene
@export var pod_scene : PackedScene
@export var druid_scene : PackedScene
@export var bear_scene : PackedScene
@export var spirit_scene : PackedScene
@export var heal_sfx : AudioStream
@export var selector : Sprite2D
@export var forest_call : String = "forest1"

@onready var top_thicket : Thicket = base_thicket
@onready var thicket_array : Array[Thicket] = [base_thicket]

static var druid_array : Array[Druid] = []

var is_activated : bool = false

func _ready() -> void:
	await get_tree().process_frame
	var druid_node = get_tree().get_first_node_in_group("druid")
	if druid_node:
		druid_array = druid_node.druid_array

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
		new_thicket.position = top_thicket.true_position
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

##heal all thickets in the forest
func heal_thickets(heal_amount:float, druid_heal:bool=false) -> void:
	if !druid_heal:
		SfxManager.play(heal_sfx,0.6)
	else:
		SfxManager.play(heal_sfx,0.02)
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
	if top_thicket:
		new_podmaker.position = top_thicket.position
	add_child(new_podmaker)
	new_podmaker.call_pods()

func attack_bears() -> void:
	if druid_array.is_empty():
		not_enough_druids.emit()
		return
	var target_druid = druid_array.pick_random()
	#TODO: visuals
	target_druid.queue_free()
	var new_bear = bear_scene.instantiate()
	if top_thicket:
		top_thicket.add_child(new_bear)
		new_bear.global_position = top_thicket.global_position + Vector2(0, -50)
	else:
		add_child(new_bear)
		new_bear.global_position = global_position + Vector2(0, -50)

##spawns a new druid at top thicket
func make_druid() -> void:
	var new_druid = druid_scene.instantiate()
	get_tree().get_first_node_in_group("spawnspace").add_child(new_druid)
	if top_thicket:
		new_druid.global_position = top_thicket.global_position
	else:
		new_druid.global_position = global_position

func make_spirit() -> void:
	var new_spirit = spirit_scene.instantiate()
	get_tree().get_first_node_in_group("spawnspace").add_child(new_spirit)
	if top_thicket:
		new_spirit.global_position = top_thicket.global_position
	else:
		new_spirit.global_position = global_position
	var tween : Tween = create_tween()
	var move_position : Vector2 = Vector2(randf_range(-70,70), randf_range(-180, -70))
	tween.tween_property(new_spirit, "position", new_spirit.position+move_position, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

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
		base_thicket = null
		top_thicket = null
	elif last_thicket != null:
		top_thicket = last_thicket
		forest_receded.emit(top_thicket.position)
