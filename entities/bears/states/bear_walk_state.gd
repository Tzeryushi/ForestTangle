extends BaseState

@export var idle_state : BaseState
@export var fall_state : BaseState
@export var roar_state : BaseState

@export var sprite : AnimatedSprite2D

const MOVE_SPEED : float = 50.0
const MOVE_GRAVITY : float = 8
const DECELERATION : float = 20
const TERMINAL_VELOCITY : float = 40

var walk_direction : float = 0.0
var should_swap : bool = false
var should_swap_roar : bool = false

func on_enter() -> void:
	super()
	should_swap = false
	should_swap_roar = false
	walk_direction = [-1.0, 1.0].pick_random()
	await get_tree().create_timer(randf_range(1.0, 4.0)).timeout
	should_swap = true
	pass

func process_input(_event:InputEvent) -> BaseState:
	return null

func process_frame(_delta:float) -> BaseState:
	if should_swap_roar:
		return roar_state
	elif should_swap:
		return idle_state
	return null

func process_physics(_delta:float) -> BaseState:
	if body.is_on_wall():
		walk_direction = -walk_direction
	sprite.flip_h = walk_direction < 0
	body.velocity.x = move_toward(body.velocity.x, MOVE_SPEED*walk_direction, DECELERATION)
	body.velocity.y = move_toward(body.velocity.y, TERMINAL_VELOCITY, MOVE_GRAVITY)
	body.move_and_slide()
	if body.velocity.y >= 0 and !body.is_on_floor():
		return fall_state
	return null

func _on_roar_timer_timeout():
	if is_active:
		should_swap_roar = true
