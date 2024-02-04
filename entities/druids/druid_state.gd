class_name DruidState
extends Node

var druid:Druid
#var move_last : Vector2 = Vector2.ZERO

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

func get_move_direction() -> Vector2:
	#gets a direction from input
	#the last direction pressed gets priority
	var value_x = sign(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var value_y = sign(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	return Vector2(value_x, value_y).normalized()
