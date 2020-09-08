extends Node2D

var pBlack = false
var p1Color = "white"
var p2Color = "black"
var gameStarted = false
var myFile = File.new()
enum {SINGLE_PLAYER, LOCAL, MULTIPLAYER}
var isMobile = false
enum {MAIN,SET,GAME,SET2}
var currentScreen = MAIN
var posi = 0
onready var camera = get_node("Camera2D")
onready var tab = get_node("TileMap")
onready var continueButton = get_node("Menu/CenterContainer/VBoxContainer/Buttons/Continue")
func _ready():
	if OS.get_name() == "Android":
		isMobile = true
	else:
		isMobile = false
	$Menu/CenterContainer/VBoxContainer/Log.text += "Plataform: " + OS.get_name() + "\n"
	$Menu/CenterContainer/VBoxContainer/Log.text += "File Loading Status(0 = OK): " + String(FileConfig.fileStats)
func Start():
	Global.gamemode = LOCAL
	get_node("debug").clear()
	if gameStarted:
		Global.pgn = ""
		get_node("Player").queue_free()
		get_node("Player2").queue_free()
		yield(get_node("Player2"),"tree_exited")
		gameStarted = false
	
	if pBlack:
		Global.Turn = "Player2"
		p1Color = "black"
		p2Color = "white"
		blackPersp()
	else:
		Global.setWhite()
		Global.Turn = "Player"
		p1Color = "white"
		p2Color = "black"
		
	var player = load("res://Scenes/Player.tscn").instance()
	add_child(player,true)
	player.get_node("TileMap").setPos("p1",p1Color)
	player.get_node("TileMap").setColor(p1Color)
	
	var player2 = load("res://Scenes/Player.tscn").instance()
	add_child(player2,true)

	player2.get_node("TileMap").setPos("p2",p2Color)
	player2.get_node("TileMap").setColor(p2Color)
	player2.myTurn = false

	get_node("dummy").visible = false
	gameStarted = true
	currentScreen = GAME
func _input(event):
	if event.is_action("ui_down") && event.is_pressed():
		yield(get_tree().create_timer(2), "timeout")
		#
		#Global.pgn = "g2g4 d7d6 g4g5 e7e5 f2f4 b8c6 d2d3 c6d4 e2e3 d4c6 e3e4 d6d5 f4f5 d8d6 g5g6 f7g6 f5f6 g7f6 e4d5 c6d4 c1d2 d6d5 b1c3 d5h1 d2e3 h1h2 d1e2 d4c2 e1d1 h2e2 d1e2 c2a1 g1f3 a1c2 e2d2 c8g4 d2c2 g4f3 e3c5 e8f7 c5a3 f8a3 b2a3 g8h6 d3d4 e5d4 c3e2 c7c5 c2d3 h6f5 d3d2 b7b5 d2e1 f3d5 e1f2 c5c4 f2e1 h7h5 e1f2 d4d3 f2e1 d3e2 e1d2 e2f1q"
		Global.Turn = "Player2"
		stockfish()
	if Global.Turn != null && get_node("dummy").visible == true:
		if event is InputEventScreenDrag && get_node(Global.Turn).pressed == true:
			event.position = get_node("Camera2D").get_global_mouse_position()
			get_node("dummy").position = event.position
	

func blackPersp():
	Global.setBlack()
	var letters = Global.letters
	var column = get_node("letters")
	var row = get_node("numbers")
	for i in 9:
		if i != 0:
			column.get_node(String(i)).text = letters[-i]
			row.get_node(String(i)).text = String(i)
func _process(delta):
	pass
func autoPlay():
	var mypgn = "d7d5 d2d3 e7e6 g1f3 d5e4 d3e4 d8d7 g2g3 b8c6 b1c3 d7d1 e1d1 g8f6 c1e3 c8d7 c3e2 f6e4 c2c3 h7h6 d1c2 a7a5 a1d1 a8d8 c2b1 a5a4 a2a3 f8d6 f1g2 e8g8 h2h4 c6e7 e2d4 c7c5 d4c2 d7c6 e3f4 d6f4 d1d8 f8d8 g3f4 d8d3 b1c1 b7b5 h1d1 c5c4 c2e1 d3d1 c1d1 e7f5 d1c2 e4f2 f3d4 f5e3 c2d2 e3g2 d4c6 g2f4 d2e3 f4d3 e1d3 c4d3 e3f2 h6h5 f2e3 f7f6 e3d3 g8f7 c6d4 e6e5 d4f3 f7e7 f3d2 e7d6 d2e4 d6e7 e4c5 f6f5 d3e3 e7f6 b2b3 a4b3 c5b3 f6e7 b3d2 e7e6 c3c4 b5c4 d2c4 e5e4 a3a4 g7g6 a4a5 e6d7 c4e5 d7e6 e5g6 e6f7 g6f4 f7e7 f4h5 e7e6 h5f4 e6d7 h4h5 d7c8 h5h6 c8b7 h6h7 b7a8 f4d5 a8a7 e3f4 a7b8 h7h8q"
	sendMoves(mypgn.substr(posi,posi+4))
	posi += 5
	pass
func stockfish():
	#This function initializes stockfish engine. Not directly, through a C++ program so it can receive inputs from a file.
	#and reads its output from the log file.
	#NOT IMPLEMENTED IN THE GAME YET
	if Global.Turn == "Player2" && Global.gamemode == SINGLE_PLAYER:
		var output = ""
		print("aaaa??")
	
		OS.execute("cmd.exe",[],true)
		return
		var err = myFile.open("C:/Users/Pedro/Documents/Stockfish/log.txt",File.READ)
		if err != 0:
			print(err)
		while output.find("bestmove") == -1:
			output = myFile.get_line()
		output = output.substr(output.find("bestmove") + 9,5)
		print("The output: ", output)
		myFile.close()
		sendMoves(output)
	pass


func sendMoves(move):
	print(move)
	var letters = Global.letters
	var player = get_node(Global.Turn)
	var pcoord = Vector2()
	var fcoord = Vector2()
	var node = Node2D.new()
	for i in letters.size():
		if letters[i] == move.left(1):
			pcoord.x = i
		if letters[i] == move.substr(2,1):
			fcoord.x = i
	pcoord.y = 8 - (move.substr(1,1).to_int())
	fcoord.y = 8 - (move.substr(3,1).to_int())
	if pBlack:
		for i in letters.size():
			if letters[i] == move.left(1):
				pcoord.x = 7 - i
			if letters[i] == move.substr(2,1):
				fcoord.x = 7 - i
		pcoord.y = (move.substr(1,1).to_int()) - 1
		fcoord.y = (move.substr(3,1).to_int()) - 1
	if move.ends_with("q"):
		player.get_node("Promotion/PromotionMenu").selected = "queen"
	if move.ends_with("r"):
		player.get_node("Promotion/PromotionMenu").selected = "rook"
	if move.ends_with("n"):
		player.get_node("Promotion/PromotionMenu").selected = "knight"
	if move.ends_with("b"):
		player.get_node("Promotion/PromotionMenu").selected = "bishop"
	print("\nCoordenadas traduzidas: ",pcoord, fcoord, "\n")
	player.pName = player.getPiece(pcoord.x,pcoord.y)
	print("move ends with: ", move.ends_with("q"))
	#if Global.Turn == "Player2":
	player.pressed = true
	player.myTurn = true
	Global.currentPiece = player.pName
	var ev = InputEventScreenTouch.new()
	ev.position = tab.map_to_world(fcoord)
	ev.pressed = true
	ev.index = 1
	player.mPieces(ev)
func checkmate(stale = false):
	var tween = get_node("Tween")
	var msg = get_node("Checkmate")
	if stale:
		msg = get_node("StaleMate")
	tween.interpolate_property(msg, "modulate", Color(1,1,1,0),Color(1,1,1,1),1.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	yield(get_tree().create_timer(2),"timeout")
	tween.interpolate_property(msg, "modulate", Color(1,1,1,1),Color(1,1,1,0),1.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	pass

func _on_Start_pressed():
	play_click()
	var tween = get_node("Tween")
	var overlay = $overlay
	overlay.modulate = Color(1,1,1,1)
	tween.interpolate_property(camera, "position",
	camera.position, Vector2(256,camera.position.y), 0.1,
	Tween.TRANS_QUAD, Tween.TRANS_LINEAR)
	tween.start()
#	tween.interpolate_property($Camera2D/cmr, "zoom",Vector2(1,1), Vector2(0.8,0.8), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
	yield(tween, "tween_completed")
	yield(get_tree().create_timer(0.5),"timeout")
	Start()
	continueButton.visible = true
	yield(get_tree().create_timer(1),"timeout")
	tween.interpolate_property(overlay, "modulate",Color(1,1,1,1), Color(1,1,1,0), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(1),"timeout")
	yield(tween, "tween_completed")
	
func _on_playingBlack_toggled(button_pressed):
	play_click()
	pBlack = button_pressed
	pass

func _on_Quit_pressed():
	get_tree().quit()
	pass

func _on_Settings_pressed():
	play_click()
	var tween = get_node("Tween")
	var settings = $Settings
	tween.interpolate_property(settings, "rect_position",
	settings.rect_position, Vector2(-820,settings.rect_position.y), 0.1,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	currentScreen = SET
	pass 


func _on_Back_pressed():
	play_click()
	print(currentScreen)
	var tween = get_node("Tween")
	var settings = $Settings
	if currentScreen == SET:
		currentScreen = MAIN
		tween.interpolate_property(settings, "rect_position",
		settings.rect_position, Vector2(-1540,settings.rect_position.y), 0.1,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
		
	elif currentScreen == SET2:
		currentScreen = SET
		FileConfig.saveConfig()
		tween.interpolate_property($PieceStyle, "rect_position",
		$PieceStyle.rect_position, Vector2(-2260,$PieceStyle.rect_position.y), 0.1,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
		
	elif currentScreen == GAME:
		currentScreen = MAIN
		tween.interpolate_property(camera, "position",
		camera.position, Vector2(-450,camera.position.y), 0.1,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
#		tween.interpolate_property($Camera2D/cmr, "zoom",Vector2(0.8,0.8),Vector2(1,1) , 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		tween.start()
		yield(get_tree().create_timer(1),"timeout")
	yield(tween, "tween_completed")
#	tween.interpolate_property(camera, "zoom",
#	camera.zoom, Vector2(1,1), 1,
#	Tween.TRANS_QUAD, Tween.EASE_OUT)
#	tween.start()

	pass

func _on_Continue_pressed():
	play_click()
	var tween = get_node("Tween")
#	tween.interpolate_property($Camera2D/cmr, "zoom",Vector2(1,1), Vector2(0.8,0.8), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
	tween.interpolate_property(camera, "position",
	camera.position, Vector2(256,camera.position.y), 0.1,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
#	tween.interpolate_property(camera, "zoom",
#	camera.zoom, Vector2(0.8,0.8), 1,
#	Tween.TRANS_CIRC, Tween.EASE_OUT)
#	tween.start()
	yield(tween, "tween_completed")
	currentScreen = GAME
	pass
	

func _on_Create_pressed():
	Network.createServer()
	yield(get_tree().create_timer(1),"timeout")
	pass

func _on_Connect_pressed():
	Network.connect_to_server()
	pass

func play_click():
	$click.play()


func _on_Board_Settings_pressed():
	play_click()
	var tween = get_node("Tween")
	var settings = $PieceStyle
	tween.interpolate_property(settings, "rect_position",
	settings.rect_position, Vector2(-820,settings.rect_position.y), 0.1,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	currentScreen = SET2
	pass

func _on_PieceStyles_style_changed():
	if gameStarted:
		$Player/TileMap.setColor(p1Color)
		$Player2/TileMap.setColor(p2Color)
	pass


func _on_playSound_toggled(button_pressed):
	
	pass
