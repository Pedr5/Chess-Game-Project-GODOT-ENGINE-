extends HBoxContainer
var style
var i = 0
var styleList = ["cburnett","cheq","leipzig","merida"]
onready var board = get_parent().get_node("StyleBoard/PreviewBoard")
signal style_changed

func _ready():
	style = FileConfig.pieceStyle
	board.setColor(style)
	$Icon/Sprite.texture = load("res://assets/pieces/" + style + "/white/kin.png")
	Global.style = style

func changeStyle():
	board.setColor(styleList[i])
	$Icon/Sprite.texture = load("res://assets/pieces/" + styleList[i] + "/white/kin.png")
	Global.style = styleList[i]
	emit_signal("style_changed")
	pass


func _on_Next_pressed():
	i += 1
	if i == styleList.size():
		i = 0
	changeStyle()

func _on_Previous_pressed():
	i -= 1
	if i < 0:
		i = styleList.size() - 1
	changeStyle()
