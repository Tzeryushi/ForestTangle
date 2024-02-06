class_name StarPath
extends Line2D

var is_pathing : bool = false


func _physics_process(_delta) -> void:
	if is_pathing and Input.is_action_pressed("draw"):
		add_point(get_local_mouse_position())

func start_pathing() -> void:
	clear_points()
	is_pathing = true
	pass

func end_pathing() -> void:
	clear_points()
	is_pathing = false
	pass

func make_end_copy(type:int=0) -> void:
	if !(type == 1 or type == 0):
		return
	var copy = self.duplicate(15)
	get_tree().get_first_node_in_group("spawnspace").add_child(copy)
	copy.z_index = 12
	copy.global_position = global_position
	copy.global_scale = global_scale
	if type == 0:
		copy.extend_and_fade()
	else:
		copy.fade_and_end()

func extend_and_fade() -> void:
	make_end_copy(1)
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", scale*1.1, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(queue_free)

func fade_and_end() -> void:
	modulate.a = 0.5
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", scale*2, 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(queue_free)
