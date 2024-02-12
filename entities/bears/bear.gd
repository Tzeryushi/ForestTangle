class_name Bear
extends CharacterBody2D

@export var state_manager : BaseStateManager
@export var spawn_sfx : AudioStream

static var bear_array : Array[Bear] = []

func _ready() -> void:
	SfxManager.play(spawn_sfx,0.5)
	state_manager.init_state(self)
	bear_array.append(self)

func _unhandled_input(_event) -> void:
	state_manager.process_input(_event)

func _process(_delta) -> void:
	state_manager.process_frame(_delta)

func _physics_process(_delta) -> void:
	state_manager.process_physics(_delta)
