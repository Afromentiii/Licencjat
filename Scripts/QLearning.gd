extends Node2D


var iter = 0
var call = Callable(self, "learn")

var players = []
var player_is_dead_counter = 0
var move : int = 0
var is_generation_dead : bool = false
var totalTimeMoves : float = 0.0
@export var path_to_conf = "res://Levels/Level0/GeneticAlgorithm0/conf.txt"

func learn():
	await get_tree().create_timer(1).timeout
	for i in players:
		i.t.start(i.life, Thread.PRIORITY_HIGH)
func _ready():
	for i in range(0,1):
		var p = preload("res://Scenes/player.tscn").instantiate()
		get_parent().call_deferred("add_child",p)
		p.position = get_parent().spawnPos
		p.respawnPosition = get_parent().spawnPos
		p.playerID = i
		p.get_node("Index").text = str(i)
		players.append(p)

	var t = Thread.new()
	t.start(call,Thread.PRIORITY_HIGH)
	
func _process(delta):
	pass
