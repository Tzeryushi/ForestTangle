extends Node2D

@export var title_music : AudioStream
@export var flags : UserFlags
@export var tutorial_button : CheckBox

func _ready() -> void:
	MusicManager.play(title_music)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear_to_db($Control/VBoxContainer2/HSlider.value))
	await get_tree().process_frame
	tutorial_button.button_pressed = flags.play_tutorial_msgs
	print(flags.play_tutorial_msgs)

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

func _on_tut_check_box_toggled(toggled_on):
	flags.set_tutorial(toggled_on)
