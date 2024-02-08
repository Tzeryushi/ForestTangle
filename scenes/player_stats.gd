class_name PlayerStats
extends Node

var star_count : int = 0
var forest_level : int = 0
var druid_count : int = 1

signal star_count_changed(new_value:int, old_value:int)
signal forest_level_changed(new_value:int, old_value:int)
signal druid_count_changed(new_value:int, old_value:int)

func _ready() -> void:
	await get_tree().process_frame
	change_star_count(star_count)
	change_forest_level(forest_level)
	change_druid_count(druid_count)

func add_star(stars_to_add:int=1) -> void:
	change_star_count(star_count+stars_to_add)

func change_star_count(new_value:int) -> void:
	var old_value : int = star_count
	star_count = new_value
	star_count_changed.emit(star_count, old_value)

func change_forest_level(new_value:int) -> void:
	var old_value : int = forest_level
	forest_level = new_value
	forest_level_changed.emit(forest_level, old_value)

func change_druid_count(new_value:int) -> void:
	var old_value : int = druid_count
	druid_count = new_value
	druid_count_changed.emit(druid_count, old_value)

func _on_main_level_forest_level_changed(new_height):
	change_forest_level(new_height)

func _on_main_level_druid_added():
	change_druid_count(druid_count+1)

func _on_shard_system_shard_collected(amount):
	change_star_count(star_count+amount)
