class_name Forest
extends Node2D

#forests are comprised of thickets, each of which have hitboxes
#thickets handle themselves, containing references to thickets before and after
#when a thicket is destroyed, it traces any thickets on top of it and destroys them too
#forests themselves handle the casting of spells and adding new thickets
#if a forest has no thickets, it triggers a signal

signal forest_lost(lost_forest:Forest)

@export var base_thicket : Thicket
@onready var top_thicket = base_thicket

##immediately grows a new thicket
func grow_thicket() -> void:
	#should instance new thicket, connect it to the last thicket
	pass

##heal all thickets in the forest
func heal_thickets() -> void:
	pass

##prompts the top thicket to grow upwards and destroy asteroids above it
func attack() -> void:
	pass
