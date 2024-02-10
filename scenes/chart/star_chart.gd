extends CanvasLayer

@export var star_dict : Dictionary
@export var chart : Control
@export var guide_scene : PackedScene
@export var guide_container : VBoxContainer
@export var constellations_ordered : Array[String]
@export var upgrade_thresholds : Array[int]
@export var upgrade_button : Button
@export var stats : PlayerStats

var is_out : bool = false

const out_position : Vector2 = Vector2(0, 145)
const in_position : Vector2 = Vector2(-357, 145)

var move_tween : Tween

signal constellation_unlocked(identifier:Globals.MAGIC)

func _ready():
	spawn_guide("grow1")
	spawn_guide("spikes")
	spawn_guide("collect")

func spawn_guide(guide_key:String) -> void:
	
	var new_guide = guide_scene.instantiate()
	guide_container.add_child(new_guide)
	guide_container.move_child(new_guide, 0)
	new_guide.change_texture(star_dict[guide_key].image)
	new_guide.set_text("[center]" + star_dict[guide_key].text)

func set_button_text(current_shards:int, needed_shards:int) -> void:
	upgrade_button.text = str(current_shards) + "/" + str(needed_shards)

func swap_positions() -> void:
	if move_tween:
		move_tween.kill()
	move_tween = create_tween()
	if is_out:
		move_tween.tween_property(chart, "position", in_position, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	else:
		move_tween.tween_property(chart, "position", out_position, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	is_out = !is_out

func _on_chart_tab_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_select"):
		swap_positions()

func _on_button_pressed():
	if constellations_ordered.is_empty():
		return
	if stats.star_count >= upgrade_thresholds[0]:
		var upgrade_amount : int = upgrade_thresholds.pop_front()
		constellation_unlocked.emit(Globals.magic_translation[constellations_ordered[0]])
		spawn_guide(constellations_ordered.pop_front())
		stats.change_star_count(stats.star_count-upgrade_amount)

func _on_player_stats_star_count_changed(new_value, _old_value):
	#TODO change button text
	upgrade_button.disabled = stats.star_count < upgrade_thresholds[0]
	set_button_text(new_value, upgrade_thresholds[0])
