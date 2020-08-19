extends Node2D

onready var grid = $CenterContainer/HBoxContainer/GridContainer

func addPiece(piece_name:String,color:String):
	var sprite = TextureRect.new()
	grid.add_child(sprite)
	sprite.rect_min_size = Vector2(32,32)
	sprite.name = piece_name
	sprite.rect_size = Vector2(32,32)
	sprite.expand = true
	sprite.stretch_mode = TextureRect.STRETCH_SCALE
	sprite.texture = load("res://assets/pieces/" + Global.style + "/" + color + "/" + piece_name.left(3)+ ".png")
	sortPawns()
	pass
func sortPawns():
	for i in grid.get_children():
		if i.name.begins_with("pawn"):
			grid.remove_child(i)
			grid.add_child(i)
	