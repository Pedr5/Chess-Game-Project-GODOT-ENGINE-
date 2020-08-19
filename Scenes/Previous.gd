tool
extends Button

func _set(property, value):
	if property=="rect_min_size":
		$bshadow.rect_size = Vector2(value.x - 25,value.y - 20)
		$ushadow.rect_size = Vector2(value.x - 25,value.y - 20)
	pass