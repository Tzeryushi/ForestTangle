extends Node2D

@export var particle_array : Array[PackedScene]

func establish() -> void:
	var particles : Array[BaseParticle] = []
	for scene in particle_array:
		var new_part = scene.instantiate()
		new_part = new_part as BaseParticle
		get_tree().root.add_child(new_part)
		new_part.play()
		particles.append(new_part)
	await get_tree().process_frame
	for particle in particles:
		particle.stop()
		particle.queue_free()
