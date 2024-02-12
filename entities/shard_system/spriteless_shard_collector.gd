extends ShardCollector


func _ready() -> void:
	var system_node = get_tree().get_first_node_in_group("shard_system")
	if system_node:
		shard_collected.connect(system_node._on_shard_collector_shard_collected)
	for area in collection_radius.get_overlapping_areas():
		_on_collection_radius_area_entered(area)
	for area in attraction_radius.get_overlapping_areas():
		_on_attraction_radius_area_entered(area)


func _on_attraction_radius_area_entered(area):
	if area is ShardHitbox:
		if !area.get_is_collecting():
			area.move_shard(self)
