extends Button

onready var table = load("res://new_tileset.tres")
func _ready():
	$test.pressed = FileConfig.showPastMove
	_on_showMovesBtn_toggled($test.pressed)
	pass

func _on_showMovesBtn_toggled(button_pressed):
	if button_pressed:
		$test.rect_position.x = 48
		$test.text = "ON"
		$test.pressed = true
		table.tile_set_modulate(3,Color("4500c3ff"))
	else:
		$test.rect_position.x = -8
		$test.text = "OFF"
		$test.pressed = false
		table.tile_set_modulate(3,Color("0000c3ff"))
	FileConfig.showPastMove = button_pressed
	FileConfig.saveConfig()
	pass
