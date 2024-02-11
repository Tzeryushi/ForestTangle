class_name StarShard
extends Node2D

##spawned by the shard system upon asteroid destruction
##contains an area that the collector interacts with
##shards will disappear after a little bit

@export var sprite : Sprite2D

var shard_value : int = 1
##true when collected by sigil
var is_being_collected : bool = false

signal collected
signal destructed(shard_ref:StarShard)

func _ready() -> void:
	scale = Vector2.ZERO

func spawn() -> void:
	scale = Vector2.ZERO
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func start_collection(new_position:Vector2, time:float=1.5) -> void:
	#TODO: Make trail propagate
	is_being_collected = true
	sprite.scale = Vector2(1,1)
	pop_sprite()
	move_to_position(new_position, time)

func move_to_position(new_position:Vector2, time:float=1.5) -> void:
	var tween : Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "scale", Vector2(0.3,0.3), time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "global_position", new_position, time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)

func pop_sprite() -> void:
	var copy = sprite.duplicate(15)
	get_tree().get_first_node_in_group("spawnspace").add_child(copy)
	copy.z_index = -3
	copy.global_position = global_position
	copy.global_scale = global_scale
	copy.modulate.a = 0.5
	var tween : Tween = create_tween()
	tween.tween_property(copy, "scale", copy.scale*2, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(copy, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(copy.queue_free)

func collect() -> void:
	collected.emit()
	destruct()

func destruct() -> void:
	destructed.emit(self)
	await get_tree().process_frame
	queue_free()
