extends TileMap
var piecesPos = {
	"rook":Vector2(0,7),
	"rook2":Vector2(7,7),
	"knight":Vector2(1,7),
	"knight2":Vector2(6,7),
	"bishop":Vector2(2,7),
	"bishop2":Vector2(5,7),
	"queen":Vector2(3,7),
	"king":Vector2(4,7),
	"pawn":Vector2(0,6),
	"pawn2":Vector2(1,6),
	"pawn3":Vector2(2,6),
	"pawn4":Vector2(3,6),
	"pawn5":Vector2(4,6),
	"pawn6":Vector2(5,6),
	"pawn7":Vector2(6,6),
	"pawn8":Vector2(7,6)
}
var piecesPos2 = {
	"rook":Vector2(0,0),
	"rook2":Vector2(7,0),
	"knight":Vector2(1,0),
	"knight2":Vector2(6,0),
	"bishop":Vector2(2,0),
	"bishop2":Vector2(5,0),
	"queen":Vector2(3,0),
	"king":Vector2(4,0),
	"pawn":Vector2(0,1),
	"pawn2":Vector2(1,1),
	"pawn3":Vector2(2,1),
	"pawn4":Vector2(3,1),
	"pawn5":Vector2(4,1),
	"pawn6":Vector2(5,1),
	"pawn7":Vector2(6,1),
	"pawn8":Vector2(7,1)
}
var sprite = Sprite
func setColor(style):
	var color = "black"
	var piece
	var node = piecesPos.keys() + piecesPos.keys()
	for i in 32:
		piece = get_children()[i]
		if piece.name.ends_with("B"):
			color = "black"
		else:
			color = "white"
		piece.texture = load("res://assets/pieces/" + style + "/" + color + "/" + piece.name.left(3) + ".png")
func setPos():
	var node
	var vec
	for i in 16: 
		node = piecesPos.keys()[i]
		vec = piecesPos.values()[i]
		var piece = sprite.new()
		add_child(piece, true)
		piece.name = node
		piece.position = map_to_world(vec)
		var piece2 = sprite.new()
		vec = piecesPos2.values()[i]
		add_child(piece2, true)
		piece2.name = node + "B"
		piece2.position = map_to_world(vec)
		piece.scale = Vector2(0.8,0.8)
		piece2.scale = Vector2(0.8,0.8)
		piece.centered = false
		piece2.centered = false
func _ready():
	setPos()
	setColor(FileConfig.pieceStyle)
func _on_PreviewBoard_visibility_changed():
	pass
