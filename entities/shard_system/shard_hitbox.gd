class_name ShardHitbox
extends Area2D

@export var star_shard : StarShard

func collect_value() -> int:
	star_shard.collect()
	return star_shard.shard_value

func move_shard(new_position:Vector2, time:float=1.5) -> void:
	star_shard.start_collection(new_position, time)

func get_is_collecting() -> bool:
	return star_shard.is_being_collected
