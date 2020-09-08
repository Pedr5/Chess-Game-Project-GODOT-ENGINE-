extends Button

onready var table = load("res://new_tileset.tres")
var isPress
func _ready():
	isPress = FileConfig.showPastMove
	print(isPress)
	_on_showMovesBtn_toggled(isPress)
	pass

func _on_showMovesBtn_toggled(button_pressed):
	$test.pressed = isPress
	if isPress:
		$test.rect_position.x = 48
		table.tile_set_modulate(3,Color("4500c3ff"))
		isPress = false
	else:
		$test.rect_position.x = -8
		table.tile_set_modulate(3,Color("0000c3ff"))
		isPress = true

	FileConfig.showPastMove = $test.pressed
	FileConfig.saveConfig()
	pass
