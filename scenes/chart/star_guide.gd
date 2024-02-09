extends VBoxContainer


func change_texture(new_texture:Texture2D) -> void:
	$TextureRect.texture = new_texture

func set_text(new_text:String) -> void:
	$RichTextLabel.text = new_text
