extends DruidState

@export var idle_state : DruidState
@export var fall_state : DruidState

@export var state_timer : Timer
@export var sprite : AnimatedSprite2D

const MOVE_SPEED : float = 50.0
const MOVE_GRAVITY : float = 8
const DECELERATION : float = 20
const TERMINAL_VELOCITY : float = 40

var walk_direction : float
var should_swap_idle : bool = false

#druids will choose to enter one of the three states (heal, shoot, move)
#from idle. This is random.

func on_enter() -> void:
	#decide direction to move and how long
	should_swap_idle = false
	walk_direction = [-1.0, 1.0].pick_random()
	state_timer.wait_time = randf_range(2.0, 6.0)
	state_timer.start()
	await state_timer.timeout
	should_swap_idle = true

func on_exit() -> void:
	state_timer.stop()

func process_input(_event:InputEvent) -> DruidState:
	#execute when actor receives input
	#returns the state of the actor, which may have changed
	return null

func process_frame(_delta:float) -> DruidState:
	if should_swap_idle:
		return idle_state
	return null

func process_physics(_delta:float) -> DruidState:
	sprite.flip_h = walk_direction > 0
	druid.velocity.x = move_toward(druid.velocity.x, MOVE_SPEED*walk_direction, DECELERATION)
	druid.velocity.y = move_toward(druid.velocity.y, TERMINAL_VELOCITY, MOVE_GRAVITY)
	druid.move_and_slide()
	if druid.velocity.y >= 0 and !druid.is_on_floor():
		return fall_state
	return null
