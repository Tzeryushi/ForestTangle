extends Node2D

##handles input to game
##when forest buttons are used, selects the forest for drawing
##if another forest is selected, overrides the last one

@export var forests : Array[Forest]
@export var sky_circle : SkyCircle

var active_forest : Forest = null

func _unhandled_input(event) -> void:
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

func _on_sky_circle_grow_casted():
	if active_forest:
		active_forest.grow_thicket()
		sky_circle.deactivate_circle()
		remove_active_forest()

func _on_sky_circle_attack_spikes_casted():
	if active_forest:
		active_forest.attack_spikes()
		sky_circle.deactivate_circle()
		remove_active_forest()
