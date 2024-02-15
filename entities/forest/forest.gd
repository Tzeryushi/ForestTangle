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

@export_category("Forest")
@export var base_thicket: Thicket
@export var forest_call: String = "forest1"

@export_group("Resources")
@export var thicket_scene: PackedScene
@export var spike_scene: PackedScene
@export var pod_scene: PackedScene
@export var druid_scene: PackedScene
@export var bear_scene: PackedScene
@export var spirit_scene: PackedScene
@export var needler_scene: PackedScene
@export var spawn_part_scene: PackedScene
@export var heal_sfx: AudioStream
@export var selector: Sprite2D

static var druid_array: Array[Druid] = []

var is_activated: bool = false

@onready var top_thicket: Thicket = base_thicket
@onready var thicket_array: Array[Thicket] = [base_thicket]


func _ready() -> void:
	# Link the druid array if there is an extant druid
	await get_tree().process_frame
	var druid_node = get_tree().get_first_node_in_group("druid")
	if druid_node:
		druid_array = druid_node.druid_array


## Activates forest for drawing - called by level
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


##immediately grows a new thicket in the designated forest
func grow_thicket() -> void:
	#should instance new thicket, connect it to the last thicket
	var new_thicket : Thicket = thicket_scene.instantiate()
	new_thicket = new_thicket as Thicket
	
	# Checking if a base thicket already exists
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
	move_child(new_thicket, 0)	# For y sorting purposes
	
	if base_thicket == new_thicket:
		new_thicket.position = new_thicket.position + Vector2(0.0, new_thicket.thicket_height)
	forest_grown.emit(Vector2(new_thicket.position.x, new_thicket.position.y-new_thicket.thicket_height))
	new_thicket.pop_up()


##heal all thickets in the forest
func heal_thickets(heal_amount: float, druid_heal: bool=false) -> void:
	if !druid_heal:
		SfxManager.play(heal_sfx,0.6)
	else:
		SfxManager.play(heal_sfx,0.02)
	for thicket in thicket_array:
		for child in thicket.get_children():
			if child is Health:
				child.heal(heal_amount)


## Spawns a spikes scene to attack upwards
func attack_spikes() -> void:
	var new_spikes = _instantiate_entity_at_top(spike_scene)
	new_spikes.spawn()


## Spawns a podmaker to launch seedpod scenes
func attack_pods() -> void:
	var new_podmaker = pod_scene.instantiate()
	new_podmaker = new_podmaker as Podmaker
	if top_thicket:
		new_podmaker.position = top_thicket.position
	add_child(new_podmaker)
	new_podmaker.call_pods()


## Attaches a new bear scene to the top thicket using the transferable property
func attack_bears() -> void:
	if druid_array.is_empty():
		not_enough_druids.emit()
		return
	
	# Removes a random druid for the spell cost
	var target_druid = druid_array.pick_random()
	target_druid.queue_free()
	
	var new_bear = bear_scene.instantiate()
	if top_thicket:
		top_thicket.add_transferable_child(new_bear)
		new_bear.global_position = top_thicket.global_position + Vector2(0, -50)
	else:
		add_child(new_bear)
		new_bear.global_position = global_position + Vector2(0, -50)
	
	_play_spawn_particles(new_bear)


## Spawns a new druid at top thicket
func make_druid() -> void:
	var new_druid = _instantiate_entity_at_top(druid_scene)
	_play_spawn_particles(new_druid)
	var tween : Tween = create_tween()
	var move_position : Vector2 = Vector2(randf_range(-70,70), randf_range(-180, -70))
	tween.tween_property(new_druid, "position", new_druid.position+move_position, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)


## Spawns a new spirit at top thicket
func make_spirit() -> void:
	var new_spirit = _instantiate_entity_at_top(spirit_scene)
	_play_spawn_particles(new_spirit)
	var tween : Tween = create_tween()
	var move_position : Vector2 = Vector2(randf_range(-70,70), randf_range(-180, -70))
	tween.tween_property(new_spirit, "position", new_spirit.position+move_position, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


## Spawns a new needler ent at top thicket
func make_needles() -> void:
	var new_needler = _instantiate_entity_at_top(needler_scene)
	_play_spawn_particles(new_needler)
	var tween: Tween = create_tween()
	var move_position := Vector2(randf_range(-70,70), randf_range(-180, -70))
	tween.tween_property(new_needler, "position", new_needler.position+move_position, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)


func get_top_location() -> Vector2:
	if top_thicket == null:
		return Vector2.ZERO
	return top_thicket.position


func get_stack_size() -> int:
	return thicket_array.size()


## Instantiates a particle as a child of the argument node
func _play_spawn_particles(node: Node2D) -> void:
	var new_parts = spawn_part_scene.instantiate()
	new_parts = new_parts as BaseParticle
	node.add_child(new_parts)
	new_parts.play()


## Instantiates an entity outside the forest node at the top thicket
func _instantiate_entity_at_top(packed_scene: PackedScene) -> Node:
	var new_scene = packed_scene.instantiate()
	var space = get_tree().get_first_node_in_group("spawnspace")
	
	if space:
		space.add_child(new_scene)
	if top_thicket:
		new_scene.global_position = top_thicket.global_position
	else:
		new_scene.global_position = global_position
	return new_scene


## thickets handle their own destruction, but signals from the forest are generated here
func _on_thicket_destructed(thicket_node: Thicket, last_thicket: Thicket):
	thicket_array.erase(thicket_node)
	
	if thicket_node == base_thicket:
		forest_lost.emit()
		base_thicket = null
		top_thicket = null
	elif last_thicket != null:
		top_thicket = last_thicket
		forest_receded.emit(top_thicket.position)
