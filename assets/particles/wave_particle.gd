extends BaseParticle


@export var particles : GPUParticles2D
@export var particles2 : GPUParticles2D

func play() -> void:
	particles.emitting = true
	particles2.emitting = true

func stop() -> void:
	particles.emitting = false
	particles2.emitting = false
	finished.emit()
