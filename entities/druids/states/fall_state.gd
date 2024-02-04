extends DruidState

@export var idle_state : DruidState

const FALL_GRAVITY : float = 8
const DECELERATION : float = 20
const TERMINAL_VELOCITY : float = 400.0

#druids will choose to enter one of the three states (heal, shoot, move)
#from idle. This is random.

func on_enter() -> void:
	#execute when state is entered
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
	druid.velocity.x = move_toward(druid.velocity.x, 0, DECELERATION)
	druid.velocity.y = move_toward(druid.velocity.y, TERMINAL_VELOCITY, FALL_GRAVITY)
	druid.move_and_slide()
	if druid.is_on_floor():
		return idle_state
	return null
