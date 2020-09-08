extends Node2D

var pos = Vector2()
var rpos = Vector2()
var pressed = false
var moved = false
var pName
var piece
var playerId
var elPassant = []
var KingMoved = false
var rook1Moved = false
var rook2Moved = false
var isPassant = false
var piecesPos
var enColor
var myTurn = false
var captures = []
var captures2 = []
var KingCheck = false
var canCastle = true
var xnm = false
var isPromoted = null
var file = File.new()
var moves
var isMobile = false
enum {SINGLE_PLAYER, LOCAL, MULTIPLAYER}
onready var dummy = get_parent().get_node("dummy")
onready var tween = get_node("TileMap/Tween")
onready var tab = get_node("TileMap2")
onready var menu = get_node("Promotion/PromotionMenu")
var king
var trans_speed
signal changed_turn

func getPiece(x,y):
	var i = 0
	var value_list = Global.piecesPos.values() + Global.piecesPos2.values()
	var name_list = Global.piecesPos.keys() + Global.piecesPos2.keys()
	while value_list[i] != Vector2(x,y):
		i += 1
		if i == 32:
			return ""
			break
	return(name_list[i]) 
	pass

func _ready():
	isMobile = get_parent().isMobile
	if !isMobile:
		trans_speed = 0.3
	else:
		trans_speed = 0.3
	if self.name == "Player":
		playerId = 1
		piecesPos = Global.piecesPos
	else:
		playerId = -1
		piecesPos = Global.piecesPos2
	if get_parent().pBlack:
		if playerId == 1:
			enColor = "white"
		else:
			enColor = "black"
	else:
		if playerId == 1:
			enColor = "black"
		else:
			enColor = "white"
	pass

func updatePos(a,b):
	if playerId == 1:
		Global.piecesPos.erase(a)
		Global.piecesPos[a] = b
	else:
		Global.piecesPos2.erase(a)
		Global.piecesPos2[a] = b
	pass


func checkPassant(x,y):
	var pList
	if playerId == 1:
		pList = get_parent().get_node("Player2").elPassant
	else:
		pList = get_parent().get_node("Player").elPassant
	
	if pList.has(getPiece(x,y)):
		return true
	return false
func checkAlt(x,y, isPawn = false, checking = false):
	king = piecesPos["king"]
	
	var p2
	if !isPawn:
		if x > 7 || x < 0:
			return false
		if y > 7 || y < 0:
			return false

	if !isPawn:
		if playerId == 1:
			p2 = Global.piecesPos.values()
		else:
			p2 = Global.piecesPos2.values()
		
		for i in p2.size():
			if(p2[i].x == x && p2[i].y == y):
				
				return false
		
	if playerId == 1:
		p2 = Global.piecesPos2.values()
	elif playerId == -1:
		p2 = Global.piecesPos.values()
	
	for i in p2.size():
		if(p2[i].x == x && p2[i].y == y):
			#print("ACHEI CAPTURA")
			if checking || !Global.currentPiece.begins_with("paw"):
					captures2.append(Vector2(x,y))
				#print("ACHEI CAPTURA 2")
			return false
	
	return true

func isOnCheck(x,y):
	KingCheck = false
	var kingPos = Vector2(x,y)
#	#print("searching straight")
	#Search straight 
	for i in 8:
		if i != 0:
			if !(checkAlt(kingPos.x + i, kingPos.y,false,true)):
				break
			#tabe.set_cell(kingPos.x + i,kingPos.y,4)
	for i in 8:
		if i != 0:
			if !(checkAlt(kingPos.x - i, kingPos.y,false,true)):
				break
			##tabe.set_cell(kingPos.x - i,kingPos.y,4)
	#YY
	for i in 8:
		if i != 0:
			if !(checkAlt(kingPos.x, kingPos.y + i,false,true)):
				break
			#tabe.set_cell(kingPos.x,kingPos.y + i,4)
	for i in 8:
		if i != 0:
			if !(checkAlt(kingPos.x, kingPos.y - i,false,true)):
				break
			#tabe.set_cell(kingPos.x,kingPos.y-i,4)
			
	for i in captures2.size():
		##tabe.set_cell(captures[i].x,captures[i].y,4)
		if getPiece(captures2[i].x,captures2[i].y).begins_with("rook") || getPiece(captures2[i].x,captures2[i].y).begins_with("queen") :
			#print(pName," CHECK FROM STRAIGHT ",getPiece(captures2[i].x,captures2[i].y))
			captures2.clear()
			KingCheck = true
			break
	captures2.clear()
#	#print("searching diagonal")
	#Search Diagonals
	for i in 8:
		if i != 0:
			if !(checkAlt(kingPos.x + i, kingPos.y+i,false,true)):
				break
			#tabe.set_cell(kingPos.x + i,kingPos.y+i,4)
	for i in 8:
		if i != 0:
			if !(checkAlt(kingPos.x - i, kingPos.y-i,false,true)):
			
				break
			#tabe.set_cell(kingPos.x - i,kingPos.y-i,4)
	#YY
	for i in 8:
		if i != 0:
			if !(checkAlt(kingPos.x+i, kingPos.y - i, false,true)):
				break
			#tabe.set_cell(kingPos.x+i,kingPos.y - i,4)
	for i in 8:
		if i != 0:
			if !(checkAlt(kingPos.x-i, kingPos.y+i,false,true)):
				break
			#tabe.set_cell(kingPos.x-i,kingPos.y+i,4)
	if !captures2.empty():
		#print("Nao VAZIA", captures2)
		for i in captures2.size():
			#print("DENOVO", captures2)
			##tabe.set_cell(captures2[i].x,captures2[i].y,4)
#			#print("names: ",getPiece(captures2[i].x,captures2[i].y))
			if getPiece(captures2[i].x,captures2[i].y).begins_with("bishop") || getPiece(captures2[i].x,captures2[i].y).begins_with("queen") :
				#print("CHECK FROM DIAGONAL",getPiece(captures2[i].x,captures2[i].y))
				captures2.clear()
				KingCheck = true
				break
	captures2.clear()
#	#print("searching knights")
	#Search for knights
	for i in 8:
		for h in 8:
			if !(h == kingPos.y || i == kingPos.x) && !(h > kingPos.y + 2 || h < kingPos.y - 2) && !(i > kingPos.x + 2 || i < kingPos.x - 2):
				if!(abs(i - kingPos.x) == 1 && abs(h - kingPos.y) == 1):
					if!(abs(i - kingPos.x) == 2 && abs(h - kingPos.y) == 2) && checkAlt(i,h,false,true):
						playerId == playerId
						#captures2.append(Vector2(i,h))
						#tabe.set_cell(i,h,4)
	if !captures2.empty():
		for i in captures2.size():
			#print("names: ",getPiece(captures2[i].x,captures2[i].y))
			if getPiece(captures2[i].x,captures2[i].y).begins_with("knight"):
				
				#print("CHECK FROM KNIGHT")
				captures2.clear()
				KingCheck = true
				
				break
	captures2.clear()
#	#print("searching pawns")
	#Search for pawns
	checkAlt(kingPos.x + 1, kingPos.y - 1 * playerId,false,true)

	checkAlt(kingPos.x - 1, kingPos.y - 1 * playerId,false,true)
	if !captures2.empty():
		for i in captures2.size():
			#print("names: ",getPiece(captures2[i].x,captures2[i].y))
			if getPiece(captures2[i].x,captures2[i].y).begins_with("pawn"):
				#print("CHECK FROM PAWN")
				captures2.clear()
				KingCheck = true
				break
	captures2.clear()
	#last but not least xD
	#search for kings
	checkAlt(kingPos.x + 1,kingPos.y + 1,false,true)
	checkAlt(kingPos.x + 1,kingPos.y - 1,false,true)
	checkAlt(kingPos.x - 1,kingPos.y - 1,false,true)
	checkAlt(kingPos.x - 1,kingPos.y + 1,false,true)
	checkAlt(kingPos.x, kingPos.y + 1,false,true)
	checkAlt(kingPos.x, kingPos.y-1,false,true)	
	checkAlt(kingPos.x + 1, kingPos.y,false,true)
	checkAlt(kingPos.x - 1, kingPos.y,false,true)
	
	if !captures2.empty():
		for i in captures2.size():
			#print("names: ",getPiece(captures2[i].x,captures2[i].y))
			if getPiece(captures2[i].x,captures2[i].y) == "king":
				#print("CHECK FROM KING?")
				captures2.clear()
				KingCheck = true
				break
	captures2.clear()
	return KingCheck
	pass
func setPassant(elp):
	elPassant.append(elp)
	pass
func clearPassant():
	get_parent().get_node("Player").elPassant.clear()
	get_parent().get_node("Player2").elPassant.clear()
func clearPiece():
	var temp = Global.piecesPos.values()
	var temp2 = Global.piecesPos2.values()
	var index
	var a
	for i in Global.piecesPos.size():
		for h in Global.piecesPos.size():
			if temp[i] == temp2[h] && temp[i].y < 20:
				if Global.Turn == "Player":
					index = i
					a = Global.piecesPos.keys()
					get_parent().get_node("Player").get_node("TileMap/" + a[index]).position.x = 5000
					Global.piecesPos.erase(a[index])
					Global.piecesPos[a[index]] = Vector2(30,30)
					get_parent().get_node("infoBar1").addPiece(a[index],enColor)
					xnm = true
				if Global.Turn == "Player2":
					index = h
					a = Global.piecesPos2.keys()
					get_parent().get_node("Player2").get_node("TileMap/" + a[index]).position.x = 5000
					Global.piecesPos2.erase(a[index])
					Global.piecesPos2[a[index]] = Vector2(30,30)
					get_parent().get_node("infoBar2").addPiece(a[index],enColor)
					xnm = true
func setMoved():
	if !piece.name.begins_with("pawn"):
		clearPassant()
	tab.clear()
	myTurn = false
	Global.justMoved("")
	yield(tween, "tween_all_completed")
	Global.justMoved(self.name)
	self.z_index = 0
	clearPiece()
	if playerId == 1:
		get_parent().get_node("Player2").firstCheck()
	else:
		get_parent().get_node("Player").firstCheck()
	emit_signal("changed_turn")
	output(piece,rpos,pos)
	#yield(get_tree().create_timer(2), "timeout")
	#get_parent().autoPlay()
	#get_parent().stockfish()
func genFEN():
	pass
	var pos = Global.piecesPos2.values()
	var names = Global.piecesPos2.keys()
	var fen:String
	for k in 8:
		for j in 8:
			for i in pos.size() - 1:
				if pos[i]== Vector2(k,j):
					fen += names[i]
			
			
			


func output(target,rpos,pos):
	genFEN()
	var err = file.open("res://Engine/input.txt",File.WRITE)
	if err != 0:
		print("Erro loading file: ", err)
	var debug = get_parent().get_node("debug")
	var letters = Global.letters
	var pcoord 
	var fcoord
	debug.clear()
	debug.set_cell(rpos.x,rpos.y,3)
	debug.set_cell(pos.x,pos.y,3)
	pcoord = letters[rpos.x]
	fcoord = letters[pos.x]
	
	pcoord += String(8 - rpos.y)
	fcoord += String(8 - pos.y)
	if get_parent().pBlack:
		pcoord = letters[7 - rpos.x]
		fcoord = letters[7 - pos.x]
		pcoord += String(rpos.y+1)
		fcoord += String(pos.y+1)
	Global.pgn += " " + (pcoord + fcoord)
	
	
	if isPromoted != null:
		Global.pgn += isPromoted
	isPromoted = ""
	if playerId == 1 && Global.gamemode == MULTIPLAYER:
		rpc('sendMoves',pcoord + fcoord + isPromoted)
	#var text = nm + Global.letters[pos.x] + String(8-pos.y)
	isPromoted = null
	var text = "setoption name Debug Log File value log.txt\n"+"isready\n" + "ucinewgame\n"+ "setoption name UCI_LimitStrength value true\n" + "position startpos moves " + Global.pgn + "\n" + "go movetime 1000\n"
	file.store_string(text)
	file.close()
	#print(text)
#	var label = Label.new()
#	get_parent().get_node("Output/List").add_child(label ,true)
#	label.text = (text)
	xnm = false
	pass

remote func sendMoves(move):
	get_parent().sendMoves(move)

func doTransition(target,rpos,pos):
	get_node("TileMap").set_cell(king.x,king.y, -1)
	if(target.name == "king"):
		get_node("TileMap").set_cell(rpos.x,rpos.y, -1)
	piece.modulate  = Color(1,1,1,1)
	canCastle = true
	dummy.position.x = 5000
	get_node("TileMap/Selection").position = tab.map_to_world(Vector2(20,20))
	self.z_index = 5
	tween.interpolate_property(target, "position",
	tab.map_to_world(rpos), tab.map_to_world(pos), trans_speed,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	get_parent().get_node("audio").play()
	
func firstCheck():
	king = piecesPos["king"]
	if isOnCheck(king.x,king.y):
		get_node("TileMap").set_cell(king.x,king.y, 4)
		canCastle = false
		isMate()
#	else:
#		isMate(true)
	if get_node("TileMap").get_node("rook").position.x > 4000:
		rook1Moved = true
	if get_node("TileMap").get_node("rook2").position.x > 4000:
		rook2Moved = true
	
func isMate(noCheck = false):
	var all_moves = []
	for i in piecesPos.keys():
		pName = i
		pressed = true
		myTurn = true
		Global.currentPiece = pName
		var ev = InputEventScreenTouch.new()
		ev.position = tab.map_to_world(Vector2(-50,-50))
		ev.pressed = true
		ev.index = 1
		mPieces(ev,true)
		all_moves += moves
	if all_moves.empty():
		king = piecesPos["king"]
		print("kingcheck: ",KingCheck)
		if noCheck:
			get_parent().checkmate(true)
			return
		get_parent().checkmate()
	pName = null
	pressed = false
	myTurn = false
	pass

func promote(pawn,new_pos):
	var selected = null
	myTurn = false
	if playerId == 1:
		piecesPos = Global.piecesPos
	else:
		piecesPos = Global.piecesPos2
	var color
	if Global.gamemode == LOCAL:
		menu.visible = true
	else:
		if playerId == 1:
			menu.visible = true
	if playerId == 1:
		if get_parent().pBlack:
			color = "black"
		else:
			color = "white"
	else:
		if get_parent().pBlack:
			color = "white"
		else:
			color = "black"
	print("SAINDO")
	if playerId == 1 || Global.gamemode == LOCAL:
		yield()	
	isPromoted = menu.selected.left(1)
	piecesPos.erase(pawn)
	pawn = menu.selected + pawn
	piece.name = pawn
	piecesPos[pawn] = new_pos
	piece.get_node("Button/Icon").texture = load("res://assets/pieces/"+ Global.style+"/" + color + "/" +  menu.selected.left(3) + ".png")
	menu.selected = null
	pass

func check(x,y, isPawn = false, checking = false):
	var tempPos
	if playerId == 1:
		piecesPos = Global.piecesPos
	else:
		piecesPos = Global.piecesPos2
	
	king = piecesPos["king"]
	if pName == "king":
		king.x = x
		king.y = y
	if pName == "king" || pName.begins_with("knight"):
		tempPos = piecesPos[pName]
		updatePos(pName, Vector2(x,y))
		if isOnCheck(king.x,king.y):
			updatePos(pName, tempPos)
			return false
		updatePos(pName, tempPos)

	if pName.begins_with("paw") && isPawn:
		tempPos = piecesPos[pName]
		updatePos(pName, Vector2(x,y))
		if isOnCheck(king.x,king.y):
			updatePos(pName, tempPos)
			return true
		updatePos(pName, tempPos)
		
	var p2
	if !isPawn:
		if x > 7 || x < 0:
			return false
		if y > 7 || y < 0:
			return false

	if !isPawn:
		if playerId == 1:
			p2 = Global.piecesPos.values()
		else:
			p2 = Global.piecesPos2.values()
		
		for i in p2.size():
			if(p2[i].x == x && p2[i].y == y):
				return false
		
	if playerId == 1:
		p2 = Global.piecesPos2.values()
	elif playerId == -1:
		p2 = Global.piecesPos.values()
	
	for i in p2.size():
		if(p2[i].x == x && p2[i].y == y):
			#print("ACHEI CAPTURA")
			if checking || !Global.currentPiece.begins_with("paw"):
					tempPos = piecesPos[pName]
					updatePos(pName, Vector2(x,y))
					king = piecesPos["king"]
					if isOnCheck(king.x,king.y):
						updatePos(pName, tempPos)
					else:	
						captures.append(Vector2(x,y))
					updatePos(pName, tempPos)
					#print("ACHEI CAPTURA 2")
			return false
	
	return true


func _input(event):
	var sendInput = false
	if event is InputEventScreenTouch && myTurn:
			if !event.is_pressed():
					return
			if Global.gamemode == MULTIPLAYER && playerId != 1:
				print("haha")
				return
			king = piecesPos["king"]
			event.position = get_parent().get_node("Camera2D").get_global_mouse_position()
			pos = tab.world_to_map(event.position)
			pName = Global.currentPiece
			print(self.name,pos,pName,", Pressed = ", pressed,", Moved = ", moved)
			mPieces(event)
			if !pressed:
				piece.modulate  = Color(1,1,1,1)
	if event is InputEventScreenDrag && pName != null && myTurn && dummy.visible == true:
		piece.modulate  = Color(1,1,1,0)

func mPieces(event,isChecking = false):
	if playerId == 1:
		piecesPos = Global.piecesPos
	else:
		piecesPos = Global.piecesPos2
	moves = []
	if (moved == false):
			if(pName != null):
				piece = get_node("TileMap/"+pName)
				if piece != null:
					if (Global.gamemode == LOCAL || Global.gamemode == MULTIPLAYER ) && dummy.visible:
						dummy.texture = piece.get_node("Button/Icon").texture
				if pName.begins_with("pawn"):
					rpos = tab.world_to_map(piece.position)
					if !(pressed):
						tab.clear()
						pos = piece.position
						get_node("TileMap/Selection").position = pos
						pos = tab.world_to_map(pos)
						if (check(pos.x, pos.y - 1 * playerId)):
							var tempPos = piecesPos[pName]
							updatePos(pName, Vector2(pos.x,pos.y - 1 * playerId))
							king = piecesPos["king"]
							if isOnCheck(king.x,king.y):
								updatePos(pName, tempPos)
							else:	
								tab.set_cell(pos.x,pos.y - 1 * playerId,0)
								
							updatePos(pName, tempPos)
							pressed = true
							if (pos.y == 6) && playerId == 1:
								if (check(pos.x, pos.y - 2 * playerId)):
									tempPos = piecesPos[pName]
									updatePos(pName, Vector2(pos.x,pos.y - 2 * playerId))
									king = piecesPos["king"]
									if isOnCheck(king.x,king.y):
										updatePos(pName, tempPos)
									else:	
										tab.set_cell(pos.x,pos.y - 2 * playerId,0)
										
									updatePos(pName, tempPos)
							if (pos.y == 1) && playerId == -1:
								if (check(pos.x, pos.y - 2 * playerId)):
									tempPos = piecesPos[pName]
									updatePos(pName, Vector2(pos.x,pos.y - 2 * playerId))
									king = piecesPos["king"]
									if isOnCheck(king.x,king.y):
										updatePos(pName, tempPos)
									else:	
										tab.set_cell(pos.x,pos.y - 2 * playerId,0)
									updatePos(pName, tempPos)
							
						if !(check(pos.x + 1, pos.y - 1 * playerId,true)):
								tab.set_cell(pos.x + 1,pos.y - 1 * playerId,1)
						if !(check(pos.x - 1, pos.y - 1 * playerId,true)):
								tab.set_cell(pos.x - 1,pos.y - 1 * playerId,1)
								
						if !(check(pos.x -1, pos.y,true)):
							if checkPassant(pos.x - 1,pos.y):
								tab.set_cell(pos.x - 1,pos.y - 1 * playerId,1)
						if !(check(pos.x + 1, pos.y,true)):
							if checkPassant(pos.x + 1,pos.y):
								tab.set_cell(pos.x + 1,pos.y - 1 * playerId,1)
						pressed = true
					else:
						rpos = tab.world_to_map(piece.position)
						pos = tab.world_to_map(event.position)
						if rpos != pos:
							if (check(rpos.x, rpos.y - 1 * playerId)):
								var tempPos = piecesPos[pName]
								updatePos(pName, Vector2(rpos.x,rpos.y - 1 * playerId))
								king = piecesPos["king"]
								if isOnCheck(king.x,king.y):
									updatePos(pName, tempPos)
								else:
									moves.append(Vector2(rpos.x,rpos.y - 1 * playerId))
								updatePos(pName, tempPos)
								pressed = true
								if (rpos.y == 6) && playerId == 1:
									if (check(rpos.x, rpos.y - 2 * playerId)):
										tempPos = piecesPos[pName]
										updatePos(pName, Vector2(rpos.x,rpos.y - 2 * playerId))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											moves.append(Vector2(rpos.x,rpos.y - 2 * playerId))
										updatePos(pName, tempPos)
								if (rpos.y == 1) && playerId == -1:
									if (check(rpos.x, rpos.y - 2 * playerId)):
										tempPos = piecesPos[pName]
										updatePos(pName, Vector2(rpos.x,rpos.y - 2 * playerId))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											moves.append(Vector2(rpos.x,rpos.y - 2 * playerId))
										updatePos(pName, tempPos)

							if !(check(rpos.x + 1, rpos.y - 1 * playerId,true)):
								moves.append(Vector2(rpos.x + 1,rpos.y - 1 * playerId))

							if !(check(rpos.x - 1, rpos.y - 1 * playerId,true)):
								moves.append(Vector2(rpos.x - 1,rpos.y - 1 * playerId))
							
							if !(check(rpos.x - 1, rpos.y,true)) && checkPassant(rpos.x - 1,rpos.y):
								moves.append(Vector2(rpos.x - 1, rpos.y - 1 * playerId))
							
							if !(check(rpos.x + 1, rpos.y,true)) && checkPassant(rpos.x + 1,rpos.y):
								moves.append(Vector2(rpos.x + 1, rpos.y - 1 * playerId))
							
							#if checkPassant(rpos.x + 1,rpos.y):
								#tab.set_cell(rpos.x + 1,rpos.y - 1 * playerId,1)
							
							moves = moves + captures
							
							for i in moves.size():
									if pos == moves[i]:
										if abs(rpos.y - pos.y) == 2:
											clearPassant()
											setPassant(piece.name)
											isPassant = true
											doTransition(piece, rpos, pos)
											updatePos(pName,pos)
											setMoved()
											continue
										else:
											elPassant.clear()
											isPassant = false
										if pos.y == 0 || pos.y == 7:
											var state = promote(pName,pos)
											if playerId == 1 || Global.gamemode == LOCAL:
												yield(menu,"hide")
												state.resume()
										doTransition(piece, rpos, pos)
										updatePos(piece.name,pos)
										setMoved()
										yield(tween, "tween_all_completed")
									
										captures.append(Vector2(rpos.x + 1, rpos.y - 1 * playerId))
										captures.append(Vector2(rpos.x + 1, rpos.y + 1 * playerId))
										captures.append(Vector2(rpos.x - 1, rpos.y - 1 * playerId))
										captures.append(Vector2(rpos.x - 1, rpos.y + 1 * playerId))
										
										if captures.has(pos):
											var a
											
											if checkPassant(pos.x,pos.y + 1 * playerId):
												if checkPassant(pos.x,pos.y + 1 * playerId):
													a = getPiece(pos.x,pos.y + 1 * playerId)
												if playerId == 1:
													get_parent().get_node("Player2").get_node("TileMap/" + a).position.x = 5000
													Global.piecesPos2.erase(a)
													Global.piecesPos2[a] = Vector2(0,30)
													xnm = true
												else:
													get_parent().get_node("Player").get_node("TileMap/" + a).position.x = 5000
													Global.piecesPos.erase(a)
													Global.piecesPos[a] = Vector2(0,30)
													xnm = true
										if !isPassant:
											clearPassant()
										continue
						get_node("TileMap/Selection").position = tab.map_to_world(Vector2(20,20))				
						dummy.position.x = 5000
						captures.clear()
						tab.clear()
						pressed = false
						Global.currentPiece = null
				if pName.begins_with("rook"):
					if (!pressed):
							tab.clear()
							pos = piece.position
							get_node("TileMap/Selection").position = pos
							pos = tab.world_to_map(pos)
							#show possible moves
							#XX
							for i in 8:
								if i != 0:
									if !(check(pos.x, pos.y + i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x,pos.y + i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x,pos.y+ i,0)
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x, pos.y - i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x,pos.y - i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											
											updatePos(pName, tempPos)
										else:
											tab.set_cell(pos.x,pos.y- i,0)
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x - i, pos.y)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x - i,pos.y))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x - i,pos.y,0)
										updatePos(pName, tempPos)
										
							for i in 8:
								if i != 0:
									if !(check(pos.x + i, pos.y)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x + i,pos.y))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x + i,pos.y,0)
										updatePos(pName, tempPos)
							for i in captures.size():
								tab.set_cell(captures[i].x,captures[i].y,1)
							pressed = true
							
					else:
						pos = tab.world_to_map(piece.position)
						rpos = tab.world_to_map(event.position)
						if rpos != pos:
							for i in 8:
								if i != 0:
									if !(check(pos.x, pos.y + i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x,pos.y + i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											moves.append(Vector2(pos.x,pos.y+ i))
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x, pos.y - i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x,pos.y - i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:
											moves.append(Vector2(pos.x,pos.y- i))
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x - i, pos.y)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x - i,pos.y))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											moves.append(Vector2(pos.x - i,pos.y))
										updatePos(pName, tempPos)
										
							for i in 8:
								if i != 0:
									if !(check(pos.x + i, pos.y)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x + i,pos.y))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											moves.append(Vector2(pos.x + i,pos.y))
										updatePos(pName, tempPos)
							pos = tab.world_to_map(event.position)
							rpos = tab.world_to_map(piece.position)
						pressed = false
						get_node("TileMap/Selection").position = tab.map_to_world(Vector2(20,20))
						dummy.position.x = 5000
						tab.clear()
						Global.currentPiece = null
						moves = moves + captures
						
						for i in moves.size():
							if pos == moves[i]:
								if pName == "rook2":
									rook2Moved = true
								else:
									rook1Moved = true
								doTransition(piece, rpos, pos)
								updatePos(pName,pos)
								setMoved()
								break
						captures.clear()
						tab.clear()
						get_node("TileMap/Selection").position = tab.map_to_world(Vector2(20,20))
						dummy.position.x = 5000
						pressed = false
						Global.currentPiece = null
				if pName.begins_with("knight"):
					if (!pressed):
						tab.clear()
						pos = tab.world_to_map(piece.position)
						get_node("TileMap/Selection").position = piece.position
						rpos = tab.world_to_map(event.position)
						
						for i in 8:
							for h in 8:
								if !(h == pos.y || i == pos.x) && !(h > pos.y + 2 || h < pos.y - 2) && !(i > pos.x + 2 || i < pos.x - 2):
									if!(abs(i - pos.x) == 1 && abs(h - pos.y) == 1):
										if!(abs(i - pos.x) == 2 && abs(h - pos.y) == 2) && check(i,h):
											tab.set_cell(i,h, 0)
											
											
						pressed = true
						
						for i in captures.size():
							tab.set_cell(captures[i].x,captures[i].y,1)

					else:

						rpos = piece.position
						rpos = tab.world_to_map(rpos)	
						pos = tab.world_to_map(event.position)

						if rpos != pos:
							for i in 8:
								for h in 8:
									if !(h == rpos.y || i == rpos.x) && !(h > rpos.y + 2 || h < rpos.y - 2) && !(i > rpos.x + 2 || i < rpos.x - 2):
										if!(abs(i - rpos.x) == 1 && abs(h - rpos.y) == 1):
											if!(abs(i - rpos.x) == 2 && abs(h - rpos.y) == 2) && check(i,h):
												#if (pos.x == i && pos.y == h) && check(pos.x,pos.y) || captures.has(Vector2(pos.x,pos.y)):
												moves.append(Vector2(i,h))
							moves += captures
							if moves.has(pos):
								
								doTransition(piece, rpos, pos)
								updatePos(pName,pos)
								setMoved()						
						get_node("TileMap/Selection").position = tab.map_to_world(Vector2(20,20))
						captures.clear()
						tab.clear()
						pressed = false
						Global.currentPiece = null
						dummy.position.x = 5000
				
				if pName.begins_with("bishop"):
					if (!pressed):
							tab.clear()
							pos = piece.position
							get_node("TileMap/Selection").position = pos
							pos = tab.world_to_map(pos)
							#show possible moves
							#XX
							for i in 8:
								if i != 0:
									if !(check(pos.x + i, pos.y + i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x + i,pos.y + i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x + i,pos.y+ i,0)
										updatePos(pName, tempPos)
							for i in 8:
								
								if i != 0:
									if !(check(pos.x - i, pos.y - i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x - i,pos.y - i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											
											updatePos(pName, tempPos)
										else:
											tab.set_cell(pos.x - i,pos.y- i,0)
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x - i, pos.y + i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x - i,pos.y + i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x - i,pos.y+ i,0)
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x + i, pos.y-i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x + i,pos.y - i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x + i,pos.y- i,0)
										updatePos(pName, tempPos)
							for i in captures.size():
								tab.set_cell(captures[i].x,captures[i].y,1)
							pressed = true
							captures.clear()
					else:
						pos = tab.world_to_map(piece.position)
						rpos = tab.world_to_map(event.position)
						if rpos != pos:
							for i in 8:
								if i != 0:
									if !(check(pos.x + i, pos.y + i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x + i,pos.y + i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											
											updatePos(pName, tempPos)
										else:	
											moves.append(Vector2(pos.x + i,pos.y+ i))
										updatePos(pName, tempPos)
							for i in 8:
								
								if i != 0:
									if !(check(pos.x - i, pos.y - i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x - i,pos.y - i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											
											updatePos(pName, tempPos)
										else:
											moves.append(Vector2(pos.x - i,pos.y- i))
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x - i, pos.y + i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x - i,pos.y + i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											moves.append(Vector2(pos.x - i,pos.y+ i))
										updatePos(pName, tempPos)
										
							for i in 8:
								if i != 0:
									if !(check(pos.x + i, pos.y-i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x + i,pos.y - i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											moves.append(Vector2(pos.x + i,pos.y- i))
										updatePos(pName, tempPos)
									
							pos = tab.world_to_map(event.position)
							rpos = tab.world_to_map(piece.position)
							moves = moves + captures
							#print(moves)
							#print("cap ",captures)
							for i in moves.size():
								if pos == moves[i]:
									doTransition(piece, rpos, pos)
									updatePos(pName,pos)
									setMoved()
									#print("bla") 
									continue
						captures.clear()
						tab.clear()
						get_node("TileMap/Selection").position = tab.map_to_world(Vector2(20,20))
						dummy.position.x = 5000
						pressed = false
						Global.currentPiece = null
				if pName.begins_with("queen"):
						if (!pressed):
							tab.clear()
							pos = piece.position
							get_node("TileMap/Selection").position = pos
							pos = tab.world_to_map(pos)
							for i in 8:
								if i != 0:
									if !(check(pos.x, pos.y + i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x,pos.y + i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x,pos.y+ i,0)
											
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x, pos.y - i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x,pos.y - i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											
											updatePos(pName, tempPos)
										else:
											tab.set_cell(pos.x,pos.y- i,0)
											
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x - i, pos.y)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x - i,pos.y))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x - i,pos.y,0)
											
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x + i, pos.y)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x + i,pos.y))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x + i,pos.y,0)
											
										updatePos(pName, tempPos)
							#diagonal
							#X
							for i in 8:
								if i != 0:
									if !(check(pos.x + i, pos.y + i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x + i,pos.y + i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x + i,pos.y+ i,0)
											
										updatePos(pName, tempPos)
							for i in 8:
								
								if i != 0:
									if !(check(pos.x - i, pos.y - i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x - i,pos.y - i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											
											updatePos(pName, tempPos)
										else:
											tab.set_cell(pos.x - i,pos.y- i,0)
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x - i, pos.y + i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x - i,pos.y + i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x - i,pos.y+ i,0)
										updatePos(pName, tempPos)
							for i in 8:
								if i != 0:
									if !(check(pos.x + i, pos.y-i)):
										break
									else:
										var tempPos = piecesPos[pName]
										updatePos(pName, Vector2(pos.x + i,pos.y - i))
										king = piecesPos["king"]
										if isOnCheck(king.x,king.y):
											updatePos(pName, tempPos)
										else:	
											tab.set_cell(pos.x + i,pos.y- i,0)
											
										updatePos(pName, tempPos)
							pressed = true
							for i in captures.size():
								tab.set_cell(captures[i].x,captures[i].y,1)
							pressed = true
							captures.clear()
						else:
							
							pos = tab.world_to_map(piece.position)
							rpos = tab.world_to_map(event.position)
							if rpos != pos:#If is different than its own position
								for i in 8:
									if i != 0:
										if !(check(pos.x, pos.y + i)):
											break
										else:
											var tempPos = piecesPos[pName]
											updatePos(pName, Vector2(pos.x,pos.y + i))
											king = piecesPos["king"]
											if isOnCheck(king.x,king.y):
												updatePos(pName, tempPos)
											else:	
												moves.append(Vector2(pos.x,pos.y+ i))
											updatePos(pName, tempPos)
								for i in 8:
									if i != 0:
										if !(check(pos.x, pos.y - i)):
											break
										else:
											var tempPos = piecesPos[pName]
											updatePos(pName, Vector2(pos.x,pos.y - i))
											king = piecesPos["king"]
											if isOnCheck(king.x,king.y):
												updatePos(pName, tempPos)
											else:
												moves.append(Vector2(pos.x,pos.y- i))
											updatePos(pName, tempPos)
								for i in 8:
									if i != 0:
										if !(check(pos.x - i, pos.y)):
											break
										else:
											var tempPos = piecesPos[pName]
											updatePos(pName, Vector2(pos.x - i,pos.y))
											king = piecesPos["king"]
											if isOnCheck(king.x,king.y):
												updatePos(pName, tempPos)
											else:	
												moves.append(Vector2(pos.x - i,pos.y))
											updatePos(pName, tempPos)	
								for i in 8:
									if i != 0:
										if !(check(pos.x + i, pos.y)):
											break
										else:
											var tempPos = piecesPos[pName]
											updatePos(pName, Vector2(pos.x + i,pos.y))
											king = piecesPos["king"]
											if isOnCheck(king.x,king.y):
												updatePos(pName, tempPos)
											else:	
												moves.append(Vector2(pos.x + i,pos.y))
											updatePos(pName, tempPos)
								#DIAGONAL
								for i in 8:
									if i != 0:
										if !(check(pos.x + i, pos.y + i)):
											break
										else:
											var tempPos = piecesPos[pName]
											updatePos(pName, Vector2(pos.x + i,pos.y + i))
											king = piecesPos["king"]
											if isOnCheck(king.x,king.y):
												
												updatePos(pName, tempPos)
											else:	
												moves.append(Vector2(pos.x + i,pos.y+ i))
											updatePos(pName, tempPos)
								for i in 8:
									
									if i != 0:
										if !(check(pos.x - i, pos.y - i)):
											break
										else:
											var tempPos = piecesPos[pName]
											updatePos(pName, Vector2(pos.x - i,pos.y - i))
											king = piecesPos["king"]
											if isOnCheck(king.x,king.y):
												
												updatePos(pName, tempPos)
											else:
												moves.append(Vector2(pos.x - i,pos.y- i))
											updatePos(pName, tempPos)
								for i in 8:
									if i != 0:
										if !(check(pos.x - i, pos.y + i)):
											break
										else:
											var tempPos = piecesPos[pName]
											updatePos(pName, Vector2(pos.x - i,pos.y + i))
											king = piecesPos["king"]
											if isOnCheck(king.x,king.y):
												updatePos(pName, tempPos)
											else:	
												moves.append(Vector2(pos.x - i,pos.y+ i))
											updatePos(pName, tempPos)
								for i in 8:
									if i != 0:
										if !(check(pos.x + i, pos.y-i)):
											break
										else:
											var tempPos = piecesPos[pName]
											updatePos(pName, Vector2(pos.x + i,pos.y - i))
											king = piecesPos["king"]
											if isOnCheck(king.x,king.y):
												updatePos(pName, tempPos)
											else:	
												moves.append(Vector2(pos.x + i,pos.y- i))
											updatePos(pName, tempPos)
								pos = tab.world_to_map(event.position)
								rpos = tab.world_to_map(piece.position)
								moves = moves + captures
								
								for i in moves.size():
									if pos == moves[i]:
										doTransition(piece, rpos, pos)
										updatePos(pName,pos)
										setMoved() 
										
							captures.clear()
							get_node("TileMap/Selection").position = tab.map_to_world(Vector2(20,20))
							dummy.position.x = 5000
							tab.clear()
							
						
							pressed = false
							Global.currentPiece = null
				if pName.begins_with("king"):
					if (!pressed):
						tab.clear()
						pos = piece.position
						get_node("TileMap/Selection").position = pos
						pos = tab.world_to_map(pos)
						#show possible moves
						#XX
						
						
						if (check(pos.x + 1,pos.y + 1)):
							tab.set_cell(pos.x + 1,pos.y + 1,0)
						if (check(pos.x + 1,pos.y - 1)):
							tab.set_cell(pos.x + 1,pos.y - 1,0)					
						if (check(pos.x - 1,pos.y - 1)):
							tab.set_cell(pos.x - 1,pos.y - 1,0)
						if (check(pos.x - 1,pos.y + 1)):
							tab.set_cell(pos.x - 1,pos.y + 1,0)
						if (check(pos.x, pos.y + 1)):
							tab.set_cell(pos.x,pos.y + 1,0)
						if (check(pos.x, pos.y-1)):
							tab.set_cell(pos.x ,pos.y - 1,0)
						if get_parent().pBlack:
							if (check(pos.x + 1, pos.y)):
								tab.set_cell(pos.x + 1,pos.y,0)
								if !KingMoved && !rook2Moved && canCastle && check(pos.x + 2, pos.y) && check(pos.x + 3, pos.y):
									tab.set_cell(pos.x + 2,pos.y,0)
							if (check(pos.x - 1, pos.y)):
								tab.set_cell(pos.x - 1,pos.y,0)
								if !KingMoved && !rook1Moved && canCastle && (check(pos.x - 2, pos.y)):
									tab.set_cell(pos.x - 2,pos.y,0)
						else:
							if (check(pos.x + 1, pos.y)):
								tab.set_cell(pos.x + 1,pos.y,0)
								if !KingMoved && !rook2Moved && canCastle && check(pos.x + 2, pos.y):
									tab.set_cell(pos.x + 2,pos.y,0)
							if (check(pos.x - 1, pos.y)):
								tab.set_cell(pos.x - 1,pos.y,0)
								if !KingMoved && !rook1Moved && canCastle && (check(pos.x - 2, pos.y)) && check(pos.x - 3, pos.y):
									tab.set_cell(pos.x - 2,pos.y,0)
						for i in captures.size():
								tab.set_cell(captures[i].x,captures[i].y,1)
						pressed = true
						captures.clear()
					else:
						pos = tab.world_to_map(piece.position)
						rpos = tab.world_to_map(event.position)
						if rpos != pos:
							var i = 1
							if (check(pos.x + 1,pos.y + 1)):
								moves.append(Vector2(pos.x + 1,pos.y + 1))	
							if (check(pos.x + 1,pos.y - 1)):
								moves.append(Vector2(pos.x + 1,pos.y - 1))					
							if (check(pos.x - 1,pos.y - 1)):
								moves.append(Vector2(pos.x - 1,pos.y - 1))
							if (check(pos.x - 1,pos.y + 1)):
								moves.append(Vector2(pos.x - 1, pos.y + 1 ))
							if get_parent().pBlack:
								if (check(pos.x + i, pos.y)):
									if !KingMoved && !rook2Moved && (check(pos.x + 2, pos.y)) && (check(pos.x + 3, pos.y)):
										moves.append(Vector2(pos.x + 2,pos.y))
									moves.append(Vector2(pos.x + i, pos.y))
								if (check(pos.x - i, pos.y)):
									if !KingMoved && !rook1Moved && (check(pos.x - 2, pos.y)):
										moves.append(Vector2(pos.x - 2,pos.y))
									moves.append(Vector2(pos.x - i,pos.y))
							else:
								if (check(pos.x + i, pos.y)):
									if !KingMoved && !rook2Moved && (check(pos.x + 2, pos.y)) :
										moves.append(Vector2(pos.x + 2,pos.y))
									moves.append(Vector2(pos.x + i, pos.y))
								if (check(pos.x - i, pos.y)):
									if !KingMoved && !rook1Moved && (check(pos.x - 2, pos.y))&& (check(pos.x - 3, pos.y)):
										moves.append(Vector2(pos.x - 2,pos.y))
									moves.append(Vector2(pos.x - i,pos.y))
							if (check(pos.x, pos.y + i)):
								moves.append(Vector2(pos.x,pos.y + i))
							if (check(pos.x, pos.y-i)):
								moves.append(Vector2(pos.x,pos.y-i))
	
							pos = tab.world_to_map(event.position)
							rpos = tab.world_to_map(piece.position)
							moves = moves + captures
							for i in moves.size():
								if pos == moves[i]:
									var rook
									var rookPos
									var offset = []
									if get_parent().pBlack:
										offset = [3,2]
									else:
										offset = [2,3]
									doTransition(piece, rpos, pos)
									if pos.x == rpos.x + 2:
										rook = get_node("TileMap/rook2")
										rookPos = tab.world_to_map(rook.position)
										tween.interpolate_property(rook, "position",
										rook.position, tab.map_to_world(Vector2(rookPos.x - offset[0],rookPos.y)), trans_speed,
										Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
										tween.start()
										updatePos("rook2",Vector2(rookPos.x - offset[0],rookPos.y))
									elif pos.x == rpos.x - 2:
										rook = get_node("TileMap/rook")
										rookPos = tab.world_to_map(rook.position)
										tween.interpolate_property(rook, "position",
										rook.position, tab.map_to_world(Vector2(rookPos.x + offset[1],rookPos.y)), trans_speed,
										Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
										tween.start()
										updatePos("rook",Vector2(rookPos.x + offset[1],rookPos.y))
									updatePos(pName,pos)
									tab.clear()
									KingMoved = true
									setMoved() 
									
						captures.clear()
						tab.clear()
						get_node("TileMap/Selection").position = tab.map_to_world(Vector2(20,20))
						dummy.position.x = 5000
						pressed = false
						Global.currentPiece = null
	

