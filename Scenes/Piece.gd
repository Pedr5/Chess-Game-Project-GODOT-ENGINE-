extends Node2D


func _ready():
	pass

func _on_Button_pressed():
	Global.setTurn(self.name, self.get_parent().get_parent())
	
	pass
