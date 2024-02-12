class_name MainCamera
extends Camera2D

@export var move_ratio : float = 0.1
@export var forest_array : Array[Forest]

@onready var original_position : Vector2 = position
@onready var base_position : Vector2 = position

var forest_offset = Vector2.ZERO

func _ready() -> void:
	Globals.set_camera(self)
	Shake.set_camera(self)
	for forest in forest_array:
		forest.forest_grown.connect(check_change_camera)
		forest.forest_receded.connect(check_change_camera)
	
func _process(_delta) -> void:
	position = base_position + forest_offset/2 + (get_local_mouse_position()*move_ratio).limit_length(100.0)
	
func check_change_camera(forest_position:Vector2) -> void:
	if (forest_position.y) < forest_offset.y:
		set_forest_offset(min(forest_position.y, 0.0))
		return
	elif (forest_position.y > forest_offset.y):
		for forest in forest_array:
			if forest.get_top_location().y < forest_position.y:
				return
		set_forest_offset(min(forest_position.y, 0.0))

func set_forest_offset(new_offset:float) -> void:
	forest_offset.y = new_offset
	var zoom_extent = (get_viewport_rect().size.y/2) / ((get_viewport_rect().size.y/2)-forest_offset.y/2)
	var tween : Tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(zoom_extent, zoom_extent), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func get_spawnable_area() -> Rect2:
	var push_size = (get_viewport_rect().size/zoom.x) * 0.5 + Vector2(0, 150)
	return Rect2((global_position-push_size-Vector2(0,50)), Vector2(get_viewport_rect().size.x/zoom.x, 50))
