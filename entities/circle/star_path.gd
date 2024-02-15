class_name StarPath
extends Line2D

var is_pathing: bool = false


func _process(_delta) -> void:
	if is_pathing and Input.is_action_pressed("draw"):
		add_point(get_local_mouse_position())


## Called by parent node to start line drawing each physics frame
func start_pathing() -> void:
	clear_points()
	is_pathing = true
	pass


func end_pathing() -> void:
	clear_points()
	is_pathing = false
	pass


## Called by the circle when a constellation is formed
## Recurses to form two copies for visual effects
func make_end_copy(type: int = 0) -> void:
	# Type 0 is the bouncing copy, type 1 is the growing property
	if !(type == 1 or type == 0):
		return
	var copy = self.duplicate(15)
	
	var space = get_tree().get_first_node_in_group("spritespace")
	if space:
		space.add_child(copy)
	
	copy.z_index = 12
	copy.global_position = global_position
	copy.global_scale = global_scale
	
	if type == 0:
		copy._bounce_and_fade()
	else:
		copy._grow_and_fade()


func _bounce_and_fade() -> void:
	make_end_copy(1)
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale",
			scale*1.1, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "modulate:a",
			0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(queue_free)


func _grow_and_fade() -> void:
	modulate.a = 0.5
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale",
			scale*2, 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(self, "modulate:a",
			0.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(queue_free)
