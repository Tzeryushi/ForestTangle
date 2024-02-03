class_name Forest
extends Node2D

#forests are comprised of thickets, each of which have hitboxes
#thickets handle themselves, containing references to thickets before and after
#when a thicket is destroyed, it traces any thickets on top of it and destroys them too
#forests themselves handle the casting of spells and adding new thickets
#if a forest has no thickets, it triggers a signal

signal forest_lost(lost_forest:Forest)
signal forest_grown(position:Vector2)
signal forest_receded(position:Vector2)

@export var base_thicket : Thicket
@export var thicket_scene : PackedScene
@export var forest_call : String = "forest1"

@onready var top_thicket : Thicket = base_thicket

var is_activated : bool = false

func _unhandled_input(event) -> void:
	if is_activated:
		if Input.is_action_just_pressed("ui_up"):
			grow_thicket()

##activates forest for drawing
func activate() -> void:
	is_activated = true
	print(forest_call + " activated")

func deactivate() -> void:
	is_activated = false
	print(forest_call + " deactivated")

##immediately grows a new thicket
func grow_thicket() -> void:
	#should instance new thicket, connect it to the last thicket
	var new_thicket : Thicket = thicket_scene.instantiate()
	new_thicket = new_thicket as Thicket
	
	if base_thicket == null:
		base_thicket = new_thicket
		new_thicket.position = Vector2.ZERO
	else:
		new_thicket.position = top_thicket.position
		top_thicket.next_thicket = new_thicket
		new_thicket.last_thicket = top_thicket
	top_thicket = new_thicket
	new_thicket.destructed.connect(_on_thicket_destructed)
	add_child(new_thicket)
	move_child(new_thicket, 0)
	if base_thicket == new_thicket:
		new_thicket.position = new_thicket.position + Vector2(0.0, new_thicket.thicket_height)
	forest_grown.emit(Vector2(new_thicket.position.x, new_thicket.position.y-new_thicket.thicket_height))
	new_thicket.pop_up()
	pass

##heal all thickets in the forest
func heal_thickets() -> void:
	pass

##prompts the top thicket to grow upwards and destroy asteroids above it
func attack() -> void:
	pass

func get_top_location() -> Vector2:
	if top_thicket == null:
		return Vector2.ZERO
	return top_thicket.position

func _on_thicket_destructed(thicket_node:Thicket, last_thicket:Thicket):
	if thicket_node == base_thicket:
		forest_lost.emit()
		print("Forest Lost!")
		base_thicket = null
		top_thicket = null
	elif last_thicket != null:
		top_thicket = last_thicket
		forest_receded.emit(top_thicket.position)
