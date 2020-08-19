extends Node

var colorIndex = 0
var pieceStyle = "cburnett"
var showPastMove = true
var showPoss = true
var playSound = true
var configFile = ConfigFile.new()
var path
var fileStats
var fTime = true

func _ready():
	if OS.get_name() == "Android":
		path = "user://config.cfg"
	else:
		path = "res://Scenes//config.cfg"
	fileStats = configFile.load(path)
	loadConfig()

func fTime():
	configFile.set_value("board","color",0)
	configFile.set_value("board","style","cburnett")
	configFile.set_value("board","showPastMove",true)
	configFile.set_value("board","showPoss",true)
	configFile.set_value("board","playSound",true)
	configFile.save(path)
	
func saveConfig():
	pieceStyle = Global.style
	configFile.set_value("board","color",colorIndex)
	configFile.set_value("board","style",pieceStyle)
	configFile.set_value("board","showPastMove",showPastMove)
	configFile.set_value("board","showPoss",showPoss)
	configFile.set_value("board","playSound",playSound)
	configFile.save(path)
	pass

func loadConfig():
	colorIndex = configFile.get_value("board","color",0)
	pieceStyle = configFile.get_value("board","style","cburnett")
	showPastMove = configFile.get_value("board","showPastMove",true)
	showPoss = configFile.get_value("board","showPoss",true)
	playSound = configFile.get_value("board","playSound",true)
	pass