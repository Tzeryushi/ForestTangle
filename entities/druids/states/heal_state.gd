extends DruidState

@export var idle_state : DruidState
@export var fall_state : DruidState

const IDLE_GRAVITY : float = 8
const DECELERATION : float = 20
const TERMINAL_VELOCITY : float = 40
const HEAL_CAST_TIME : float = 1.0

var should_swap_idle : bool = false
@onready var heal_time : float = HEAL_CAST_TIME

#druids will choose to enter one of the three states (heal, shoot, move)
#from idle. This is random.

func on_enter() -> void:
	heal_time = HEAL_CAST_TIME/2
	should_swap_idle = false
	await get_tree().create_timer(randf_range(2.0, 5.0)).timeout
	should_swap_idle = true

func process_input(_event:InputEvent) -> DruidState:
	#execute when actor receives input
	#returns the state of the actor, which may have changed
	return null

func process_frame(_delta:float) -> DruidState:
	if should_swap_idle:
		return idle_state
	heal_time -= _delta
	if heal_time <= 0.0:
		druid.send_heal()
		heal_time = HEAL_CAST_TIME
	return null

func process_physics(_delta:float) -> DruidState:
	druid.velocity.x = move_toward(druid.velocity.x, 0, DECELERATION)
	druid.velocity.y = move_toward(druid.velocity.y, TERMINAL_VELOCITY, IDLE_GRAVITY)
	druid.move_and_slide()
	if druid.velocity.y >= 0 and !druid.is_on_floor():
		return fall_state
	return null
