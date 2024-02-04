class_name MainLevel
extends Node2D

##handles input to game
##when forest buttons are used, selects the forest for drawing
##if another forest is selected, overrides the last one

@export var forests : Array[Forest]
@export var sky_circle : SkyCircle
@export var asteroid_timer : Timer
@export var dialoguer : DialogueLayer
@export var playing_music : AudioStream

var active_forest : Forest = null
var forest_height : float = 0.0
var danger_level : int = 0
var intro_done : bool = false

const asteroid_wait_default : float = 10.0

func _ready() -> void:
	MusicManager.play(playing_music)
	for forest in forests:
		forest.forest_grown.connect(check_change_level)
		forest.forest_receded.connect(check_change_level)
		forest.forest_lost.connect(game_lose)
	dialoguer.play_dialogue("Hell rains from the sky", 3.0)
	await dialoguer.finished
	dialoguer.play_dialogue("Should the treeline break, all will end", 4.0)
	await dialoguer.finished
	dialoguer.play_dialogue("Bolster the forest, grow to the heavens", 4.0)
	await dialoguer.finished
	dialoguer.play_dialogue("Hold 1, 2, 3, and 4 to target forests", 4.0)
	await dialoguer.finished
	dialoguer.play_dialogue("Draw upon the heavens with your mouse", 4.0)
	await dialoguer.finished
	asteroid_timer.start()
	dialoguer.play_dialogue("Follow the stars", 3.0)
	await dialoguer.finished
	intro_done = true

func _unhandled_input(_event) -> void:
	var was_no_active_forest : bool = active_forest == null
	for forest in forests:
		if Input.is_action_just_pressed(forest.forest_call):
			if !forest.is_activated:
				if active_forest:
					remove_active_forest()
				select_forest(forest)
		elif Input.is_action_just_released(forest.forest_call):
			if forest.is_activated:
				deselect_forest(forest)
	if was_no_active_forest and active_forest != null:
		sky_circle.activate_circle()
	if !was_no_active_forest and active_forest == null:
		sky_circle.deactivate_circle()

func check_change_level(forest_position:Vector2) -> void:
	if (forest_position.y) < -forest_height:
		set_forest_height(-min(forest_position.y, 0.0))
		return
	elif (forest_position.y > -forest_height):
		for forest in forests:
			if forest.get_top_location().y < forest_position.y:
				return
		set_forest_height(-min(forest_position.y, 0.0))

func select_forest(forest:Forest) -> void:
	forest.activate()
	active_forest = forest

func deselect_forest(forest:Forest) -> void:
	forest.deactivate()
	if active_forest == forest:
		active_forest = null

func remove_active_forest() -> void:
	if active_forest:
		if active_forest.is_activated:
			deselect_forest(active_forest)
		active_forest = null

func set_forest_height(new_height:float) -> void:
	forest_height = new_height
	if int(forest_height/100) != danger_level:
		danger_level = int(forest_height/100)
		asteroid_timer.wait_time = clampf(asteroid_wait_default - float(danger_level+2)*0.8, 0.12, asteroid_wait_default)
	if forest_height > 1400:
		game_win()

func druid_heal(heal_value:float) -> void:
	for forest in forests:
		forest.heal_thickets(heal_value, true)

func game_win() -> void:
	for asteroid in get_tree().get_nodes_in_group("asteroid"):
		if asteroid is Asteroid:
			asteroid.queue_free()
	asteroid_timer.stop()
	await get_tree().create_timer(2.0).timeout
	dialoguer.play_dialogue("Death is the reward of the destroyer.", 4.0)
	await dialoguer.finished
	dialoguer.play_dialogue("Your forest grows strong.", 4.0)
	await dialoguer.finished
	dialoguer.play_dialogue("Well done", 2.0)
	await dialoguer.finished
	SceneManager.switch_scene("victory_screen")

func game_lose() -> void:
	dialoguer.play_dialogue("We must prevail.", 3.0)
	await dialoguer.finished
	dialoguer.play_dialogue("Try again.", 2.0)
	await dialoguer.finished
	SceneManager.restart_scene()

func _on_sky_circle_grow_casted():
	if active_forest:
		active_forest.grow_thicket()
		sky_circle.deactivate_circle()
		remove_active_forest()
		if intro_done:
			dialoguer.play_dialogue("GROW", 2.0)
			await dialoguer.finished

func _on_sky_circle_attack_spikes_casted():
	if active_forest:
		active_forest.attack_spikes()
		sky_circle.deactivate_circle()
		remove_active_forest()
		if intro_done:
			dialoguer.play_dialogue("SPIKES", 2.0)
			await dialoguer.finished

func _on_sky_circle_attack_bears_casted():
	if active_forest:
		active_forest.attack_bears()
		sky_circle.deactivate_circle()
		remove_active_forest()
		if intro_done:
			dialoguer.play_dialogue("...BEARS?", 2.0)
			await dialoguer.finished

func _on_sky_circle_attack_pods_casted():
	if active_forest:
		active_forest.attack_pods()
		sky_circle.deactivate_circle()
		remove_active_forest()
		if intro_done:
			dialoguer.play_dialogue("PODS", 2.0)
			await dialoguer.finished

func _on_sky_circle_make_druid_casted():
	if active_forest:
		active_forest.make_druid()
		sky_circle.deactivate_circle()
		remove_active_forest()
		if intro_done:
			dialoguer.play_dialogue("NEW DRUID", 2.0)
			await dialoguer.finished

func _on_sky_circle_heal_casted():
	if active_forest:
		active_forest.heal_thickets(10.0)
		sky_circle.deactivate_circle()
		remove_active_forest()
		if intro_done:
			dialoguer.play_dialogue("HEAL", 2.0)
			await dialoguer.finished


func _on_skyman_defeated():
	game_win()
