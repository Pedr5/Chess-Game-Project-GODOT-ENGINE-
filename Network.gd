extends Node

const SERVER_IP = '192.168.15.106'
const SERVER_PORT = 6007
const MAX_PLAYERS = 2
var players = []
var move
func _ready():
	pass

func createServer():
		var peer = NetworkedMultiplayerENet.new()
		peer.create_server(SERVER_PORT,2)
		get_tree().set_network_peer(peer)
		players.append("Windows")

func connect_to_server():
	get_tree().connect("connected_to_server",self,'_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)
		
func _connected_to_server():
	players.append("client")
	rpc('sendMsg')
	
remote func sendMsg():
	if get_tree().is_network_server():
		print("CONECTOOOU")
	pass
