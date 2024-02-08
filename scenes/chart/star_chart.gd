extends CanvasLayer

@export var chart : Control

var is_out : bool = false

const out_position : Vector2 = Vector2(0, 145)
const in_position : Vector2 = Vector2(-357, 145)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func swap_positions() -> void:
	if is_out:
		chart.position = in_position
	else:
		chart.position = out_position
	is_out = !is_out

func _on_chart_tab_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_select"):
		swap_positions()

func _on_button_pressed():
	print("working")
