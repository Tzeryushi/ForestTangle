extends BaseState

@export var walk_state : BaseState
@export var fall_state : BaseState
@export var roar_state : BaseState

const IDLE_GRAVITY : float = 8
const DECELERATION : float = 20
const TERMINAL_VELOCITY : float = 40

var should_swap : bool = false
var should_swap_roar : bool = false

func on_enter() -> void:
	super()
	should_swap = false
	should_swap_roar = false
	await get_tree().create_timer(randf_range(0.1, 4.0)).timeout
	should_swap = true

func process_input(_event:InputEvent) -> BaseState:
	return null

func process_frame(_delta:float) -> BaseState:
	if should_swap_roar:
		return roar_state
	elif should_swap:
		return walk_state
	return null

func process_physics(_delta:float) -> BaseState:
	body.velocity.x = move_toward(body.velocity.x, 0, DECELERATION)
	body.velocity.y = move_toward(body.velocity.y, TERMINAL_VELOCITY, IDLE_GRAVITY)
	body.move_and_slide()
	if body.velocity.y >= 0 and !body.is_on_floor():
		return fall_state
	return null

func _on_roar_timer_timeout():
	if is_active:
		should_swap_roar = true
