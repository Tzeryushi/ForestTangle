extends DruidState

@export var idle_state : DruidState
@export var fall_state : DruidState
@export var pod_scene : PackedScene

const IDLE_GRAVITY : float = 8
const DECELERATION : float = 20
const TERMINAL_VELOCITY : float = 40
const POD_CAST_TIME : float = 1.5

var should_swap_idle : bool = false
@onready var pod_time : float = POD_CAST_TIME

#druids will choose to enter one of the three states (heal, shoot, move)
#from idle. This is random.

func on_enter() -> void:
	pod_time = POD_CAST_TIME/2
	should_swap_idle = false
	await get_tree().create_timer(randf_range(2.0, 6.0)).timeout
	should_swap_idle = true

func process_input(_event:InputEvent) -> DruidState:
	return null

func process_frame(_delta:float) -> DruidState:
	if should_swap_idle:
		return idle_state
	pod_time -= _delta
	if pod_time <= 0.0:
		send_pod()
		pod_time = POD_CAST_TIME
	return null

func process_physics(_delta:float) -> DruidState:
	druid.velocity.x = move_toward(druid.velocity.x, 0, DECELERATION)
	druid.velocity.y = move_toward(druid.velocity.y, TERMINAL_VELOCITY, IDLE_GRAVITY)
	druid.move_and_slide()
	if druid.velocity.y >= 0 and !druid.is_on_floor():
		return fall_state
	return null

func send_pod() -> void:
	var new_pod = pod_scene.instantiate()
	new_pod = new_pod as Seedpod
	var space = get_tree().get_first_node_in_group("spawnspace")
	if space:
		space.add_child(new_pod)
	new_pod.global_position = druid.global_position
	new_pod.spawn()
