extends Node2D


var iter = 0
var call = Callable(self, "learn")
var players = []
var player_is_dead_counter = 0
var move : int = 0
@export var path_to_conf = "res://Levels/Level0/GeneticAlgorithm0/conf.txt"

func learn():
	await get_tree().create_timer(2).timeout
	while true:
		if  player_is_dead_counter != len(players):
			for i in players:
				if i.is_dead == false:
					move = randi_range(0,1)
					i.move(move,randf_range(0,0.5))
				else:
					player_is_dead_counter += 1
		await get_tree().create_timer(0.5).timeout

func _ready():
	for i in range(0,8):
		var p1 = preload("res://Scenes/player.tscn").instantiate()
		get_parent().call_deferred("add_child",p1)
		p1.position = get_parent().spawnPos
		p1.respawnPosition = get_parent().spawnPos
		players.append(p1)

	var t = Thread.new()
	t.start(call,Thread.PRIORITY_HIGH)
	
	
func _process(delta):
	pass
