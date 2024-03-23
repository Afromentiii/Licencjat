extends Node2D

@export var path_to_conf = "res://Levels/Level0/GeneticAlgorithm0/conf.txt"
@export var path_to_genetic = "res://Levels/Level0/GeneticAlgorithm0/"

@onready var load_gen_button = $Control/VBoxContainer/Button
@onready var textArea = $Control/VBoxContainer/Button/TextEdit
@onready var generate_first_gen = $Control/VBoxContainer/GenerateFirstGeneration


var is_generation_dead : bool = false
var is_generation_loaded: bool = false
var is_button_just_pressed : bool = false
var is_generate_button_just_pressed : bool = false
var is_living_process_started : bool = false

var call = Callable(self, "learn")
var players = []
var player_is_dead_counter = 0
var move : int = 0
var lines = []
var gen_population = 0
var gen_last = 0

func save_players_data(gen):
	print("SAVING DATA PROCESS...")
	var generation = FileAccess.open(path_to_genetic + "gen" + str(gen) + ".txt", FileAccess.WRITE)
	for i in players:
		print(i.moves,i.reward)
		var line = str(i.reward) + " "
		for m in i.moves:
			line += str(m) + " "
		generation.store_line(line)
		i.moves.clear()
		i.reward = 0
	
	generation.close()
	
func load_players_data(path):
	print("LOADING DATA PROCESS...")
	var index = 0
	if FileAccess.file_exists(path):
		var generation = FileAccess.open(path, FileAccess.READ)
		while generation.eof_reached() == false:
			var line = generation.get_line()
			var splited_line = line.split(" ")
			for i in range(1,len(splited_line) - 1):
				players[index].moves.append(int(splited_line[i]))

			if index < len(players):
				players[index].reward = int(splited_line[0])
				index += 1
		for i in players:
			print(i.moves, i.reward)
		generation.close()
	else:
		print("File does not exist!")
			
func is_population_dead():
	for i in players:
		if i.is_dead == true:
			player_is_dead_counter += 1
		else:
			player_is_dead_counter = 0
		if player_is_dead_counter == len(players):
			is_generation_dead = true
			
func load_generation_procedure():
	if is_button_just_pressed == true:
		var path = str(path_to_genetic + "gen" + str(int(textArea.text)) + ".txt")
		if FileAccess.file_exists(path):
			is_population_dead()
			if is_generation_dead == true:
				is_generation_dead = false
				load_players_data(path)
				await get_tree().create_timer(0.1).timeout
				for i in players:
					i.t.start(i.loading, Thread.PRIORITY_HIGH)
		else:
			print("File does not exist!")
		is_button_just_pressed = false
		
func generate_first_gen_procedure():
	if is_generate_button_just_pressed == true:
		if FileAccess.file_exists(path_to_genetic + "gen1.txt"):
			print("File exits!")
		else: 
			is_population_dead()
			if is_living_process_started == false and  is_generation_dead == true:
				start_living_process()
				is_living_process_started = true
		is_generate_button_just_pressed = false
				
func start_living_process():
	for i in players:
		i.is_dead = false
		i.t.start(i.life, Thread.PRIORITY_HIGH)
	
func learn():
	await get_tree().create_timer(1).timeout

	while true:
		generate_first_gen_procedure()
		load_generation_procedure()
		
		is_population_dead()
		if is_generation_dead == true and is_living_process_started == true:
			is_generation_dead = false
			is_living_process_started = false
			print("ALL DIED :D")
			save_players_data(gen_last)
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
		
	load_players_data()
	'''
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
		p.is_dead = true
		players.append(p)

	var t = Thread.new()
	t.start(call,Thread.PRIORITY_HIGH)
	
func _process(delta):
	pass

