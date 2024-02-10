class_name MainLevel
extends Node2D

##handles input to game
##when forest buttons are used, selects the forest for drawing
##if another forest is selected, overrides the last one

@export var forests : Array[Forest]
@export var stats : PlayerStats
@export var sky_circle : SkyCircle
@export var asteroid_timer : Timer
@export var dialoguer : DialogueLayer
@export var cast_texter : CastLayer
@export var playing_music : AudioStream

var active_forest : Forest = null
var forest_height : float = 0.0
var danger_level : int = 0
var intro_done : bool = false
var end_state_triggered : bool = false
var constellation_unlocks : Dictionary = {
	Globals.MAGIC.GROW1:{"unlock":true, "call":cast_grow1},
	Globals.MAGIC.GROW2:{"unlock":false, "call":cast_grow2},
	Globals.MAGIC.GROW3:{"unlock":false, "call":cast_grow3},
	Globals.MAGIC.BEARS:{"unlock":false, "call":cast_bears},
	Globals.MAGIC.SPIKES:{"unlock":true, "call":cast_spikes},
	Globals.MAGIC.PODS:{"unlock":false, "call":cast_pods},
	Globals.MAGIC.DRUIDS1:{"unlock":false, "call":cast_druids1},
	Globals.MAGIC.DRUIDS2:{"unlock":false, "call":cast_druids2},
	Globals.MAGIC.HEAL:{"unlock":false, "call":cast_heal},
	Globals.MAGIC.COLLECT:{"unlock":true, "call":cast_collect},
}

const asteroid_wait_default : float = 5.0

signal forest_level_changed(new_height:int)
signal druid_added()
signal collect_shards_called

func _ready() -> void:
	MusicManager.play(playing_music)
	for forest in forests:
		forest.forest_grown.connect(check_change_level)
		forest.forest_receded.connect(check_change_level)
		forest.forest_lost.connect(game_lose)
	#dialoguer.play_dialogue("Hell rains from the sky", 3.0)
	#await dialoguer.finished
	#dialoguer.play_dialogue("Should the treeline break, all will end", 4.0)
	#await dialoguer.finished
	#dialoguer.play_dialogue("Bolster the forest, grow to the heavens", 4.0)
	#await dialoguer.finished
	#dialoguer.play_dialogue("Hold 1, 2, 3, and 4 to target forests", 4.0)
	#await dialoguer.finished
	#dialoguer.play_dialogue("Draw upon the heavens with your mouse", 4.0)
	#await dialoguer.finished
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
		forest_level_changed.emit(danger_level)
		asteroid_timer.wait_time = clampf(asteroid_wait_default - float(danger_level+2)*0.8, 0.12, asteroid_wait_default)
	if forest_height > 1400:
		game_win()

func druid_heal(heal_value:float) -> void:
	for forest in forests:
		forest.heal_thickets(heal_value, true)

func game_win() -> void:
	if end_state_triggered:
		return
	end_state_triggered = true
	for asteroid in get_tree().get_nodes_in_group("asteroid"):
		if asteroid is Asteroid:
			asteroid.queue_free()
	asteroid_timer.stop()
	await get_tree().create_timer(3.0).timeout
	dialoguer.play_dialogue("Death is the reward of the destroyer.", 4.0)
	await dialoguer.finished
	dialoguer.play_dialogue("Your forest grows strong.", 4.0)
	await dialoguer.finished
	dialoguer.play_dialogue("Well done", 2.0)
	await dialoguer.finished
	SceneManager.switch_scene("victory_screen")

func game_lose() -> void:
	if end_state_triggered:
		return
	end_state_triggered = true
	dialoguer.play_dialogue("We must prevail.", 3.0)
	await dialoguer.finished
	dialoguer.play_dialogue("Try again.", 2.0)
	await dialoguer.finished
	SceneManager.restart_scene()

func cast_magic(identifier:Globals.MAGIC) -> void:
	if constellation_unlocks.has(identifier):
		if constellation_unlocks[identifier]["unlock"] and active_forest:
			constellation_unlocks[identifier]["call"].call()
		elif active_forest:
			end_cast("not unlocked...")

func cast_grow1():
	active_forest.grow_thicket()
	end_cast("grow")

func cast_grow2():
	active_forest.grow_thicket()
	active_forest.grow_thicket()
	end_cast("grow two")

func cast_grow3():
	active_forest.grow_thicket()
	active_forest.grow_thicket()
	active_forest.grow_thicket()
	end_cast("grow three")

func cast_spikes():
	active_forest.attack_spikes()
	end_cast("spikes")

func cast_bears():
	active_forest.attack_bears()
	end_cast("bears...?")

func cast_pods():
	active_forest.attack_pods()
	sky_circle.deactivate_circle()
	end_cast("pods")

func cast_druids1():
	active_forest.make_druid()
	druid_added.emit()
	end_cast("new druid")

func cast_druids2():
	active_forest.make_druid()
	druid_added.emit()
	active_forest.make_druid()
	druid_added.emit()
	end_cast("two druids")

func cast_heal():
	active_forest.heal_thickets(10.0)
	end_cast("heal")

func cast_collect():
	collect_shards_called.emit()
	end_cast("collect shards")

func end_cast(cast_text:String="no text", time:float=1.0) -> void:
	sky_circle.deactivate_circle()
	remove_active_forest()
	cast_texter.play_text(cast_text, time)

func _on_skyman_defeated():
	game_win()

func _on_star_chart_constellation_unlocked(identifier):
	constellation_unlocks[identifier]["unlock"] = true
