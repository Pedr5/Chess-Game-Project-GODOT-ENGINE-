extends Node

var currentPiece
var Turn
var style
var colorIndex
var letters = ["a","b","c","d","e","f","g","h"]
var pgn = ""
var piecesPos
enum {SINGLE_PLAYER, LOCAL, MULTIPLAYER}
var gamemode = LOCAL
var piecesPos2
func _ready():
	style = FileConfig.pieceStyle
	pass 
	
func setWhite():
	 piecesPos = {
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
	 piecesPos2 = {
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
func setTurn(piece, parent):
	if parent.name == Turn:
		currentPiece = piece
		parent.myTurn = true
func justMoved(popo):
	if popo == "Player":
		Turn = "Player2"
		currentPiece = null
		get_tree().current_scene.get_node("infoBar2").setTurn(true)
		get_tree().current_scene.get_node("infoBar1").setTurn(false)
	elif popo =="Player2":
		Turn = "Player"
		currentPiece = null
		get_tree().current_scene.get_node("infoBar1").setTurn(true)
		get_tree().current_scene.get_node("infoBar2").setTurn(false)
	else:
		Turn = null
	pass

func setBlack():
	piecesPos = {
	"rook":Vector2(0,7),
	"rook2":Vector2(7,7),
	"knight":Vector2(1,7),
	"knight2":Vector2(6,7),
	"bishop":Vector2(2,7),
	"bishop2":Vector2(5,7),
	"queen":Vector2(4,7),
	"king":Vector2(3,7),
	"pawn":Vector2(0,6),
	"pawn2":Vector2(1,6),
	"pawn3":Vector2(2,6),
	"pawn4":Vector2(3,6),
	"pawn5":Vector2(4,6),
	"pawn6":Vector2(5,6),
	"pawn7":Vector2(6,6),
	"pawn8":Vector2(7,6)}
	piecesPos2 = {
	"rook":Vector2(0,0),
	"rook2":Vector2(7,0),
	"knight":Vector2(1,0),
	"knight2":Vector2(6,0),
	"bishop":Vector2(2,0),
	"bishop2":Vector2(5,0),
	"queen":Vector2(4,0),
	"king":Vector2(3,0),
	"pawn":Vector2(0,1),
	"pawn2":Vector2(1,1),
	"pawn3":Vector2(2,1),
	"pawn4":Vector2(3,1),
	"pawn5":Vector2(4,1),
	"pawn6":Vector2(5,1),
	"pawn7":Vector2(6,1),
	"pawn8":Vector2(7,1)
}


		