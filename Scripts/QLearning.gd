extends Node2D

var call = Callable(self, "learn")
@export var path_to_conf = "res://Levels/Level0/GeneticAlgorithm0/conf.txt"
@export var path_to_genetic = "res://Levels/Level0/GeneticAlgorithm0/"
@onready var load_gen_button = $Control/VBoxContainer/Button
@onready var textArea = $Control/VBoxContainer/Button/TextEdit
var players = []
var player_is_dead_counter = 0
var move : int = 0
var is_generation_dead : bool = false
var is_generation_loaded: bool = false
var is_button_just_pressed : bool = false
var lines = []
var gen_population = 0
var gen_last = 0

func save_players_data():
	var generation = FileAccess.open(path_to_genetic + "gen" + str(gen_last) + ".txt", FileAccess.WRITE)
	for i in players:
		var line = str(i.reward) + " "
		for m in i.moves:
			line += str(m) + " "
		generation.store_line(line)
		i.moves.clear()
		i.reward = 0
		
	generation.close()
	
func load_players_data():
	var generation = FileAccess.open(path_to_genetic + "gen" + str(gen_last) + ".txt", FileAccess.READ)
	while generation.eof_reached() == false:
		var line = generation.get_line()
		var splited_line = line.split(" ")
		for i in range(1,len(splited_line)):
			print(i)
			


func is_population_dead():
	for i in players:
		if i.is_dead == true:
			player_is_dead_counter += 1
		else:
			player_is_dead_counter = 0
		if player_is_dead_counter == len(players):
			is_generation_dead = true
func learn():
	await get_tree().create_timer(1).timeout
	load_players_data()
	'''
	await get_tree().create_timer(1).timeout
	for i in players:
		i.t.start(i.life, Thread.PRIORITY_HIGH)
	'''
	'''
	while true:
		if is_button_just_pressed == true:
			if FileAccess.file_exists(textArea.text):
				var generation = FileAccess.open(textArea.text, FileAccess.READ)
				while generation.eof_reached() == false:
					var line = generation.get_line()
					var splited_line = line.split(";")
			is_button_just_pressed = false
		await get_tree().create_timer(0.1).timeout
	'''
	while true:
		is_population_dead()
		if is_generation_dead == true:
			is_generation_dead = false
			print("ALL DIED :D")
			save_players_data()
			break
		await get_tree().create_timer(0.1).timeout
func _ready():
	
	if FileAccess.file_exists(path_to_conf):
		var conf = FileAccess.open(path_to_conf, FileAccess.READ)
		while conf.eof_reached() == false:
			var line = conf.get_line()
			var splited_line = line.split(" ")
			lines.append(splited_line)
			
	gen_population = int(lines[0][1])
	gen_last = int(lines[1][1])
	lines.clear()
	
	for i in range(0, gen_population):
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

