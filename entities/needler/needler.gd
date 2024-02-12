class_name Needler
extends CharacterBody2D


@export var state_manager : BaseStateManager
@export var spawn_sfx : AudioStream

static var needler_array : Array[Needler] = []

func _ready() -> void:
	SfxManager.play(spawn_sfx,0.1)
	state_manager.init_state(self)
	needler_array.append(self)

func _unhandled_input(_event) -> void:
	state_manager.process_input(_event)

func _process(_delta) -> void:
	state_manager.process_frame(_delta)

func _physics_process(_delta) -> void:
	state_manager.process_physics(_delta)
