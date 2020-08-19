extends TileMap

func setColor(color):
	if get_parent().name == "Player" && color == "black":
		Global.setBlack()
	var piecesPos = Global.piecesPos
	var piece
	var style = Global.style
	var node = piecesPos.keys()
	for i in 16:
		piece = get_node(node[i])
		piece.get_node("Button/Icon").texture = load("res://assets/pieces/" + style + "/" + color + "/" + node[i].left(3) + ".png")

func setPos(pos, color):
	var piecesPos
	var node
	var vec
	if pos == "p1":
		if color == "black":
			Global.setBlack()
		piecesPos = Global.piecesPos
	else:
		piecesPos = Global.piecesPos2
		
	for i in 16:
		node = piecesPos.keys()[i]
		vec = piecesPos.values()[i]
		var piece = load("res://Scenes/Piece.tscn").instance()
		add_child(piece, true)
		piece.name = node
		piece.position = map_to_world(vec)
	
func _ready():	
	pass
		

