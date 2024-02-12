class_name Druid
extends CharacterBody2D

@export var state_manager : StateManager

static var druid_array : Array[Druid] = []
static var druid_count : int = 0

signal heal_sent(heal_value:float)

const HEAL_STRENGTH : float = 0.5

func _ready() -> void:
	state_manager.init_state(self)
	var level_node = get_tree().get_first_node_in_group("main_level")
	if level_node:
		heal_sent.connect((level_node as MainLevel).druid_heal)
	druid_array.append(self)
	druid_count += 1

func _unhandled_input(_event) -> void:
	state_manager.process_input(_event)

func _process(_delta) -> void:
	state_manager.process_frame(_delta)

func _physics_process(_delta) -> void:
	state_manager.process_physics(_delta)

func _exit_tree() -> void:
	druid_array.erase(self)
	druid_count -= 1

func send_heal() -> void:
	heal_sent.emit(HEAL_STRENGTH)

#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
