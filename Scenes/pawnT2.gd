extends TouchScreenButton

signal teste (nome)

func _ready():
	emit_signal("teste", get_parent().name)
	pass
