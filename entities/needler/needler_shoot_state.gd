extends BaseState

@export var walk_state : BaseState
@export var fall_state : BaseState

@export var shoot_sfx : AudioStream
@export var shoot_scene : PackedScene

const IDLE_GRAVITY : float = 8
const DECELERATION : float = 20
const TERMINAL_VELOCITY : float = 40

var should_swap : bool = false

func on_enter() -> void:
	super()
	should_swap = false
	shoot()
	await get_tree().create_timer(0.3).timeout
	should_swap = true

func process_input(_event:InputEvent) -> BaseState:
	return null

func process_frame(_delta:float) -> BaseState:
	if should_swap:
		return walk_state
	return null

func process_physics(_delta:float) -> BaseState:
	body.velocity.x = move_toward(body.velocity.x, 0, DECELERATION)
	body.velocity.y = move_toward(body.velocity.y, TERMINAL_VELOCITY, IDLE_GRAVITY)
	body.move_and_slide()
	if body.velocity.y >= 0 and !body.is_on_floor():
		return fall_state
	return null

func shoot() -> void:
	SfxManager.play(shoot_sfx,0.3)
	var new_shoot = shoot_scene.instantiate()
	get_tree().get_first_node_in_group("spawnspace").add_child(new_shoot)
	new_shoot.global_position = body.global_position
