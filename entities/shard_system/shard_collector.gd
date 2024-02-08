class_name ShardCollector
extends Node2D

@export var collection_radius : Area2D
@export var attraction_radius : Area2D

signal shard_collected(number_of_shards:int)

func _ready() -> void:
	for area in collection_radius.get_overlapping_areas():
		_on_collection_radius_area_entered(area)
	for area in attraction_radius.get_overlapping_areas():
		_on_attraction_radius_area_entered(area)

func _on_collection_radius_area_entered(area):
	if area is ShardHitbox:
		shard_collected.emit(area.collect_value())

func _on_attraction_radius_area_entered(area):
	if area is ShardHitbox:
		if !area.get_is_collecting():
			area.move_shard(global_position)
