extends Node2D
var color
onready var grid = $CenterContainer/HBoxContainer/GridContainer

func addPiece(piece_name:String,n_color:String):
	color = n_color
	var sprite = TextureRect.new()
	grid.add_child(sprite)
	sprite.rect_min_size = Vector2(32,32)
	sprite.name = piece_name
	sprite.rect_size = Vector2(32,32)
	sprite.expand = true
	sprite.stretch_mode = TextureRect.STRETCH_SCALE
	sprite.texture = load("res://assets/pieces/" + Global.style + "/" + n_color + "/" + piece_name.left(3)+ ".png")
	sortPawns()
	pass
func sortPawns():
	for i in grid.get_children():
		if i.name.begins_with("pawn"):
			grid.remove_child(i)
			grid.add_child(i)

func updateTexture():
	for i in grid.get_children():
		i.texture = load("res://assets/pieces/" + Global.style + "/" + color + "/" + i.name.left(3)+ ".png")
	pass
func setTurn(turn):
	$CenterContainer/turn.visible = turn
	pass
func _on_tileColor_change_color(dcolor:Color):
	$CenterContainer/back.color = dcolor
	pass

func clear():
	for i in grid.get_children():
		grid.remove_child(i)
		i.queue_free()

func _on_PieceStyles_style_changed():
	updateTexture()
	pass
