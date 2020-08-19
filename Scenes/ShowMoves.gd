extends Node2D
onready var tween = get_node("tween")
onready var tab = get_parent().get_node("TileMap2")
var n = 0
var ball
var ball_group = []
func _ready():
	for i in 30:
		ball = load("res://Scenes/poss.tscn").instance()
		add_child(ball,true)
		ball.visible = false
		ball_group.append(ball)
	 


func _process(delta):
	pass

func _input(event):
	pass

func sendBall(cur_pos, final_pos):
	cur_pos = tab.map_to_world(cur_pos)
	final_pos = tab.map_to_world(final_pos)
	ball_group[n].visible = true
	ball_group[n].position = cur_pos
	tween.interpolate_property(ball_group[n], "position", cur_pos, final_pos, 0.25, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	tween.start()
	n += 1
	
func sendBack(final_pos):
	final_pos = tab.map_to_world(final_pos)
	for i in range(29,0,-1):
		tween.interpolate_property(ball_group[i], "position", ball_group[i].position, final_pos, 0.15, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		tween.start()
		
	yield(tween,"tween_all_completed")
	for i in n:
		ball_group[i].visible = false
	n = 0