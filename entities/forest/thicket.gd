class_name Thicket
extends Node2D
## Thickets are members of Forests that exist in a linked list.
##
## Thickets holds references to each other and can communicate
## recursively to trigger deletions and pass down node references.
## Forests hold references to thickets and add them to the structure,
## but to not handle deletion or the thicket states.
## Thicket scenes are made with health, sprite, collision, and hitbox nodes.

signal destructed(thicket_node: Thicket, last_thicket: Thicket)

@export_category("Thicket")
@export var is_base_thicket : bool = false
@export var thicket_height : float = 45.0
@export var damaged_color : Color = Color.CRIMSON

@export_group("Node References")
@export var health : Health
@export var sprite : Sprite2D
@export var floor_collision : CollisionPolygon2D

@export_group("Resources")
@export var thicket_destruct_sfx : AudioStream
@export var leaf_particles : PackedScene
@export var heal_particles : PackedScene
@export var small_heal_particles : PackedScene

var last_thicket : Thicket = null
var next_thicket : Thicket = null

## Local position where the thicket will be after animations complete
var true_position : Vector2 = Vector2.ZERO
## Array of nodes that will be preserved when the thicket is destroyed
var transfer_nodes : Array[Node]

@onready var sprite_shader : ShaderMaterial = sprite.material


func _ready() -> void:
	assert(health != null, "Health not set on " + str(self))
	assert(sprite != null, "Sprite not set on " +str(self))
	assert(floor_collision != null, "Collision node not set on " +str(self))
	
	# Setting the speed of the "swaying" sprite shader
	sprite_shader.set_shader_parameter("speed", randf_range(0.7, 2))


## Moves a new thicket into place with an animation.
##In the case that many thickets are added simultaneously, it sets and utilizes
##the true_position in order to ensure proper spawning.
func pop_up() -> void:
	floor_collision.disabled = true		# Disabled to prevent entity movement
	true_position = position - Vector2(0.0, thicket_height)
	
	var particles = leaf_particles.instantiate()
	particles = particles as BaseParticle
	var space = get_tree().get_first_node_in_group("spawnspace")
	if space:
		space.add_child(particles)
	particles.global_position = global_position - Vector2(0,thicket_height)
	particles.play()
	
	#animating upward movement of thicket
	var tween : Tween = create_tween()
	tween.tween_property(self, "position",
			true_position, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	floor_collision.disabled = false


## Handles the removal of a thicket.
## If a thicket is below other thickets, it crawls up the linked list to trigger
## destructs on them, passing down their transferable child nodes to the next
## undestroyed node.
func destruct() -> void:
	SfxManager.play(thicket_destruct_sfx, 0.4)
	
	if last_thicket != null:
		for node in transfer_nodes:
			last_thicket.call_deferred("reparent_transferable_child", node)
	
	var particles = leaf_particles.instantiate()
	particles = particles as BaseParticle
	var space = get_tree().get_first_node_in_group("spawnspace")
	if space:
		space.add_child(particles)
	
	particles.global_position = global_position - Vector2(0,thicket_height)
	particles.play()
	
	# Thicket dies and must crawl through chain to delete others before deleting itself
	if next_thicket != null:
		next_thicket.destruct()
		await next_thicket.destructed
	destructed.emit(self, last_thicket)
	await get_tree().process_frame
	
	queue_free()


## Adds to the node array that is passed down to the last thicket upon destruction
func add_transferable_child(node: Node) -> void:
	add_child(node)
	transfer_nodes.append(node)


## Reparents a given node to itself while adding to the transfer array
func reparent_transferable_child(node: Node) -> void:
	node.reparent(self)
	transfer_nodes.append(node)


func _instantiate_outside_node(packed_scene: PackedScene) -> Node:
	var new_node = packed_scene.instantiate()
	var space = get_tree().get_first_node_in_group("spawnspace")
	if space:
		space.add_child(new_node)
	return new_node


# Signal Functions

func _on_health_health_depleted():
	Shake.add_trauma(0.5)
	destruct()


func _on_health_health_changed(new_health: float):
	# Lerp towards damaged color based on health
	var health_ratio : float = new_health/health.max_health
	modulate = damaged_color.lerp(Color(1,1,1,1), health_ratio)


func _on_health_gained_life(_life: float):
	# Deciding which particles to use
	var particles_to_use = heal_particles
	if _life < 1.0:
		particles_to_use = small_heal_particles
	
	var particles = _instantiate_outside_node(particles_to_use)
	particles.global_position = global_position + Vector2(0,-20)
	particles.play()
