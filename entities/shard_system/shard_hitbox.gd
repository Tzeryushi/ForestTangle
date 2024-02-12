class_name ShardHitbox
extends Area2D

@export var star_shard : StarShard

func collect_value() -> int:
	star_shard.collect()
	return star_shard.shard_value

func move_shard(position_ref:Node2D, time:float=1.5) -> void:
	star_shard.start_collection(position_ref, time)

func get_is_collecting() -> bool:
	return star_shard.is_being_collected
