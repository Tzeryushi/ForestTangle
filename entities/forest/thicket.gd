class_name Thicket
extends Node2D

@export var is_base_thicket : bool = false
@export var health : Health
@export var sprite : Sprite2D
@export var thicket_height : float = 45.0
@export var damaged_color : Color = Color.CRIMSON
@export var thicket_destruct_sfx : AudioStream
@export var leaf_particles : PackedScene
@export var heal_particles : PackedScene
@export var small_heal_particles : PackedScene

@onready var sprite_shader : ShaderMaterial = sprite.material

var last_thicket : Thicket = null
var next_thicket : Thicket = null
##local position where the thicket will be after animations
var true_position : Vector2 = Vector2.ZERO

signal destructed(thicket_node:Thicket, last_thicket:Thicket)

func _ready() -> void:
	assert(health != null, "Health not set on " + str(self))
	sprite_shader.set_shader_parameter("speed", randf_range(0.7, 2))

##moves a new thicket into place with an animation
func pop_up() -> void:
	true_position = position - Vector2(0.0, thicket_height)
	
	var particles = leaf_particles.instantiate()
	particles = particles as BaseParticle
	get_tree().get_first_node_in_group("spawnspace").add_child(particles)
	particles.global_position = global_position - Vector2(0,thicket_height)
	particles.play()
	
	var tween : Tween = create_tween()
	tween.tween_property(self,"position", true_position, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func destruct() -> void:
	#thicket dies and must crawl through chain to delete others before deleting itself
	SfxManager.play(thicket_destruct_sfx, 0.4)
	if next_thicket != null:
		next_thicket.destruct()
		await next_thicket.destructed
	destructed.emit(self, last_thicket)
	queue_free()

func _on_health_health_depleted():
	Shake.add_trauma(0.5)
	destruct()

func _on_health_health_changed(new_health):
	var health_ratio : float = new_health/health.max_health
	modulate = damaged_color.lerp(Color(1,1,1,1), health_ratio)

func _on_health_gained_life(_life:float):
	var use_particles = heal_particles
	if _life < 1.0:
		use_particles = small_heal_particles
	var particles = use_particles.instantiate()
	particles = particles as BaseParticle
	get_tree().get_first_node_in_group("spawnspace").add_child(particles)
	particles.global_position = global_position + Vector2(0,-20)
	particles.play()
