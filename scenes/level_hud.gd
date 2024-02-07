class_name LevelHUD
extends Control

@export var druid_count : RichTextLabel
@export var forest_level : RichTextLabel
@export var shard_count : RichTextLabel

const druid_pre : String = "[wave amp=20.0 freq=2.0]Druids: "
const level_pre : String = "[wave amp=20.0 freq=2.0]Level: "
const shard_pre : String = "[wave amp=20.0 freq=2.0]Shards: "

func _on_player_stats_druid_count_changed(new_value, _old_value):
	druid_count.text = druid_pre + str(new_value)

func _on_player_stats_forest_level_changed(new_value, _old_value):
	forest_level.text = level_pre + str(new_value)

func _on_player_stats_star_count_changed(new_value, _old_value):
	shard_count.text = shard_pre + str(new_value)
