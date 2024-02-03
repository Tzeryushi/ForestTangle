class_name MagicStar
extends Node2D

##magic star will send out a signal when it encounters a path that is close to it
##it will grow larger and shine in this event, and will cease doing so on command

var is_active : bool = false

signal path_encountered(star_number:int)

##activate grows the star and spins it faster
func activate() -> void:
	pass

func deactivate() -> void:
	pass


func _on_collection_area_mouse_entered():
	#if pathing active, activate
