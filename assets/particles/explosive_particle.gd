class_name ExplosiveParticle
extends BaseParticle

@export var particles : Array[GPUParticles2D]

func _process(_delta) -> void:
	for particle in particles:
		if particle.emitting == true:
			return
	finished.emit()
	queue_free()

func play() -> void:
	for particle in particles:
		particle.emitting = true

func stop() -> void:
	for particle in particles:
		particle.emitting = false
	finished.emit()
	queue_free()
