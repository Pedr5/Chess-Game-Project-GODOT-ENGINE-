extends Control

onready var grid = $GridContainer
onready var board = load("res://new_tileset.tres")
export var lightColor = Color("ffe1be")
export var darkColor = Color("9b7259")

signal change_color

func setColor(lcolor, dcolor):
	grid.get_node("1").color = lcolor
	grid.get_node("2").color = lcolor
	grid.get_node("3").color = dcolor
	grid.get_node("4").color = dcolor
	board.tile_set_modulate(0,Color(dcolor))
	board.tile_set_modulate(1,Color(lcolor))
	emit_signal("change_color",Color(dcolor))
	
	pass

func getColors():
	return [lightColor,darkColor]
