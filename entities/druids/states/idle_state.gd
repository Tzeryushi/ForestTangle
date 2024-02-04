extends DruidState

@export var move_state : DruidState
@export var fall_state : DruidState
@export var heal_state : DruidState
@export var shoot_state : DruidState

@export var state_timer : Timer

const IDLE_GRAVITY : float = 8
const DECELERATION : float = 20
const TERMINAL_VELOCITY : float = 40

var should_swap : bool = false

#druids will choose to enter one of the three states (heal, shoot, move)
#from idle. This is random.

func on_enter() -> void:
	should_swap = false
	state_timer.wait_time = randf_range(0.1, 4.0)
	state_timer.start()
	await state_timer.timeout
	should_swap = true
	pass

func on_exit() -> void:
	state_timer.stop()

func process_input(_event:InputEvent) -> DruidState:
	return null

func process_frame(_delta:float) -> DruidState:
	if should_swap:
		return [move_state, move_state, move_state, heal_state, shoot_state].pick_random()
	return null

func process_physics(_delta:float) -> DruidState:
	druid.velocity.x = move_toward(druid.velocity.x, 0, DECELERATION)
	druid.velocity.y = move_toward(druid.velocity.y, TERMINAL_VELOCITY, IDLE_GRAVITY)
	druid.move_and_slide()
	if druid.velocity.y >= 0 and !druid.is_on_floor():
		return fall_state
	return null
