extends Node2D

@export var title_music : AudioStream

func _ready() -> void:
	MusicManager.play(title_music)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear_to_db($Control/VBoxContainer2/HSlider.value))

func _on_begin_pressed():
	SceneManager.switch_scene("main_level")

func _on_end_pressed():
	SceneManager.quit_game()


func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear_to_db(value))

func _on_check_box_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
