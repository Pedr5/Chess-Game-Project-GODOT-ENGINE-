extends Button
var isPress
func _ready():
	isPress = FileConfig.playSound
	_on_playSound_toggled(isPress)
	pass

func _on_playSound_toggled(button_pressed):
	$test.pressed = isPress
	if isPress:
		$test.rect_position.x = 62
		isPress = false
		get_tree().current_scene.get_node("audio").volume_db = 0
	else:
		$test.rect_position.x = 4

		isPress = true
		get_tree().current_scene.get_node("audio").volume_db = -80
	FileConfig.playSound = $test.pressed
	FileConfig.saveConfig()
	pass
