extends BaseState

@export var idle_state : BaseState
@export var roar_timer : Timer

const FALL_GRAVITY : float = 8
const DECELERATION : float = 20
const TERMINAL_VELOCITY : float = 400.0

var should_swap : bool = false

func on_exit() -> void:
	roar_timer.start()

func process_physics(_delta:float) -> BaseState:
	body.velocity.x = move_toward(body.velocity.x, 0, DECELERATION)
	body.velocity.y = move_toward(body.velocity.y, TERMINAL_VELOCITY, FALL_GRAVITY)
	body.move_and_slide()
	if body.is_on_floor():
		return idle_state
	return null
