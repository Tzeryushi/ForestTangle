class_name Seedpod
extends Node2D

@export var pod_spawn_sfx : AudioStream
@export var pod_hit_sfx : AudioStream
@export var pod_damage : float = 5.0
@export var acceleration : float = 0.1
@export var top_speed : float = 6.0

var target_asteroid : Asteroid = null
var direction : Vector2 = Vector2.UP
var velocity : Vector2 = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func _physics_process(_delta) -> void:
	var shifted_acceleration = acceleration
	if target_asteroid:
		var distance = (target_asteroid.global_position - global_position)
		direction = distance.normalized()
		if distance.length() < 1000 and distance.length() != 0.0:
			shifted_acceleration = acceleration + top_speed*2/distance.length()
			if distance.length() < 100:
				shifted_acceleration = shifted_acceleration*20
	else:
		seek()
	velocity += (direction * shifted_acceleration)
	velocity = velocity.limit_length(top_speed)
	global_position += velocity
	rotation = velocity.angle()

func seek() -> void:
	if target_asteroid:
		return
	for asteroid in get_tree().get_nodes_in_group("asteroid"):
		if target_asteroid and (asteroid.global_position-global_position).length() < (target_asteroid.global_position-global_position).length():
			target_asteroid = asteroid
		elif !target_asteroid:
			target_asteroid = asteroid
	if target_asteroid:
		target_asteroid.tree_exiting.connect(clear_asteroid_ref)

func spawn(new_acceleration:float=acceleration) -> void:
	SfxManager.play(pod_spawn_sfx,0.2)
	acceleration = new_acceleration

func clear_asteroid_ref() -> void:
	target_asteroid = null

func destruct() -> void:
	SfxManager.play(pod_hit_sfx,0.05)
	queue_free()

func _on_pod_hurtbox_area_entered(area):
	if area is AsteroidHitbox:
		area.take_damage(pod_damage)
	destruct()

func _on_lifetimer_timeout():
	destruct()
