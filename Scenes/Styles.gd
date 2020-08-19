extends HBoxContainer

onready var group = get_node("cburnett").group

func _ready():
	setStyle()


	
func setStyle():
	Global.style = group.get_pressed_button().name