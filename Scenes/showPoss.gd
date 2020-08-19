extends Button

onready var table = load("res://invi.tres")
func _ready():
	$test.pressed = FileConfig.showPoss
	_on_showPoss_toggled($test.pressed)
	pass

func _on_showPoss_toggled(button_pressed):
	if button_pressed:
		$test.rect_position.x = 48
		$test.text = "ON"
		$test.pressed = true
		table.tile_set_modulate(0,Color("2fb7d1"))
		table.tile_set_modulate(1,Color("f10000"))
	else:
		$test.rect_position.x = -8
		$test.text = "OFF"
		$test.pressed = false
		table.tile_set_modulate(0,Color(0))
		table.tile_set_modulate(1,Color(0))
	FileConfig.showPoss = button_pressed
	FileConfig.saveConfig()
	pass
