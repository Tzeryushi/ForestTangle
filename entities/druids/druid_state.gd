class_name DruidState
extends Node

@export var animation_type : String = ""

var druid : Druid

func on_enter() -> void:
	#execute when state is entered
	pass

func on_exit() -> void:
	#execute when when is exited into another state
	pass

func process_input(_event:InputEvent) -> DruidState:
	#execute when actor receives input
	#returns the state of the actor, which may have changed
	return null

func process_frame(_delta:float) -> DruidState:
	#execute to define process loop functionality in state
	#returns the state of the actor, which may have changed
	return null

func process_physics(_delta:float) -> DruidState:
	#execute to define physics process loop functionality in state
	#returns the state of the actor, which may have changed
	return null
