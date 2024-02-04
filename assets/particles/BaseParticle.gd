class_name BaseParticle
extends Node2D

signal finished

func play() -> void:
	finished.emit()

func stop() -> void:
	finished.emit()
