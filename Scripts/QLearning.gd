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
	while true:
		for i in players:
			if i.is_dead == false:
				var timer = randf_range(0.25, 0.5)
				move = randi_range(0,1)
				i.move(move,timer)
				totalTimeMoves += timer
		await get_tree().create_timer(totalTimeMoves).timeout
		totalTimeMoves = 0.0
		
func _ready():
	for i in range(0,2):
		var p1 = preload("res://Scenes/player.tscn").instantiate()
		get_parent().call_deferred("add_child",p1)
		p1.position = get_parent().spawnPos
		p1.respawnPosition = get_parent().spawnPos
		p1.playerID = i
		players.append(p1)

	var t = Thread.new()
	t.start(call,Thread.PRIORITY_HIGH)
	
func _process(delta):
	pass
