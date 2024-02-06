class_name StarSpriteGroup
extends CanvasGroup

func _ready() -> void:
	set_glow(false)

func set_glow(value:bool) -> void:
	(material as ShaderMaterial).set_shader_parameter("activated", value)
