class_name ShardSystem
extends Node2D

##subscribes to created asteroids, spawns stars on destruction
##stars that interact with the collection area are added to total
##references to all stars are stored within the system, which can call them in

@export var shard_scene : PackedScene

var shard_list : Array[StarShard] = []

signal shard_collected(amount:int)

func spawn_shard(shard_pos:Vector2) -> void:
	var new_shard = shard_scene.instantiate()
	new_shard = new_shard as StarShard
	shard_list.append(new_shard)
	new_shard.destructed.connect(_on_shard_destructed)
	await get_tree().process_frame
	add_child(new_shard)
	new_shard.global_position = shard_pos
	new_shard.spawn()

func _on_asteroid_spawner_asteroid_spawned(asteroid_ref:Asteroid):
	asteroid_ref.destructed.connect(_on_asteroid_destruct)

func _on_asteroid_destruct(destruct_pos:Vector2) -> void:
	spawn_shard(destruct_pos)

func _on_shard_destructed(shard_ref:StarShard) -> void:
	shard_list.erase(shard_ref)
	
