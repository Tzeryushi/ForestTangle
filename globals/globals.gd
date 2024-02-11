extends Node

enum MAGIC {GROW1=0, SPIKES=1, COLLECT=2, PODS=3, BEARS=4, HEAL=5, GROW2=6,
GROW3=7, DRUIDS1=8, DRUIDS2=9, SPIRIT=10, NEEDLES=11, WAVE=12}

var magic_translation : Dictionary = {
	"grow1":MAGIC.GROW1,
	"grow2":MAGIC.GROW2,
	"grow3":MAGIC.GROW3,
	"spikes":MAGIC.SPIKES,
	"collect":MAGIC.COLLECT,
	"pods":MAGIC.PODS,
	"heal":MAGIC.HEAL,
	"bears":MAGIC.BEARS,
	"druids1":MAGIC.DRUIDS1,
	"druids2":MAGIC.DRUIDS2,
	"spirit":MAGIC.SPIRIT,
	"needles":MAGIC.NEEDLES,
	"wave":MAGIC.WAVE
}

var camera : MainCamera

func set_camera(new_camera:MainCamera) -> void:
	camera = new_camera
func get_camera() -> MainCamera:
	return camera
