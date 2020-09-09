extends Button

onready var table = load("res://invi.tres")
var isPress
func _ready():
	isPress = FileConfig.showPoss
	_on_showPoss_toggled(isPress)
	pass

func _on_showPoss_toggled(button_pressed):
	$test.pressed = isPress
	if isPress:
		$test.rect_position.x = 62
		table.tile_set_modulate(0,Color("7b000000"))
		table.tile_set_modulate(1,Color("5eff0000"))
		isPress = false
	else:
		$test.rect_position.x = 4
		table.tile_set_modulate(0,Color(0))
		table.tile_set_modulate(1,Color(0))
		isPress = true
	FileConfig.showPoss = $test.pressed
	FileConfig.saveConfig()
	pass
