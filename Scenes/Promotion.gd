extends Control

var selected = null
onready var board = load("res://new_tileset.tres")
signal prom_selected
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$background.color = board.tile_get_modulate(0)
	if selected != null:
		self.hide()
		emit_signal("prom_selected")
	pass

func _on_prom_queen_pressed():
	selected = "queen"
	pass

func _on_prom_rook_pressed():
	selected = "rook"
	pass

func _on_prom_knight_pressed():
	selected = "knight"
	pass

func _on_prom_bishop_pressed():
	selected = "bishop"
	pass

func getSelected():
	return selected

func _on_Promotion_id_pressed(ID):
	pass
