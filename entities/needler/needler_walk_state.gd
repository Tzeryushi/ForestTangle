extends BaseState

@export var fall_state : BaseState
@export var shoot_state : BaseState

@export var sprite : AnimatedSprite2D

const MOVE_SPEED : float = 50.0
const MOVE_GRAVITY : float = 8
const DECELERATION : float = 20
const TERMINAL_VELOCITY : float = 40

var shoot_timer : SceneTreeTimer
var walk_direction : float = 1.0
var should_swap_shoot : bool = false

func on_enter() -> void:
	super()
	should_swap_shoot = false
	if shoot_timer:
		return
	#walk_direction = [-1.0, 1.0].pick_random()
	var stat_ref = get_tree().get_first_node_in_group("stats")
	while (stat_ref and is_active):
		shoot_timer = get_tree().create_timer(randf_range(2.0, 4.0))
		await shoot_timer.timeout
		shoot_timer = null
		if stat_ref.star_count > 0:
			should_swap_shoot = true
			return

func process_input(_event:InputEvent) -> BaseState:
	return null

func process_frame(_delta:float) -> BaseState:
	if should_swap_shoot:
		return shoot_state
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
