extends Button
func _ready():
	$test.pressed = FileConfig.playSound
	_on_playSound_toggled($test.pressed)
	pass

func _on_playSound_toggled(button_pressed):
	if button_pressed:
		$test.rect_position.x = 48
		$test.text = "ON"
		$test.pressed = true
		get_tree().current_scene.get_node("audio").volume_db = 0
	else:
		$test.rect_position.x = -8
		$test.text = "OFF"
		$test.pressed = false
		get_tree().current_scene.get_node("audio").volume_db = -80
	FileConfig.playSound = button_pressed
	FileConfig.saveConfig()
	pass
