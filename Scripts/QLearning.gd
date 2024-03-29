extends Node2D

@export var path_to_conf = "res://Levels/Level0/GeneticAlgorithm0/conf.txt"
@export var path_to_genetic = "res://Levels/Level0/GeneticAlgorithm0/"

@onready var load_gen_button = $Control/VBoxContainer/Button
@onready var textArea = $Control/VBoxContainer/Button/TextEdit
@onready var generate_first_gen = $Control/VBoxContainer/GenerateFirstGeneration
@onready var start_genetic_algorithm = $Control/VBoxContainer/StartGenetic

var is_generation_dead : bool = false
var is_generation_loaded: bool = false
var is_button_just_pressed : bool = false
var is_generate_button_just_pressed : bool = false
var is_living_process_started : bool = false
var is_saving : bool = false
var is_genetic_button_just_pressed : bool = false
var is_genetic_started : bool = false
var arrays_are_empty : bool = false

var call = Callable(self, "learn")
var players = []
var player_is_dead_counter = 0
var move : int = 0
var lines = []
var gen_population = 0
var gen_last = 0
var genetic_iterations = 0
var genetic_iterations_saved = 0
var genetic_iter = 0
var player_moves_is_empty_counter = 0

func overide_conf():
	var conf = FileAccess.open(path_to_conf, FileAccess.WRITE)
	conf.store_line("GENERATION_POPULATION " + str(gen_population))
	conf.store_line("LAST_GENERATION " + str(gen_last))
	conf.close()

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
	if is_button_just_pressed == true and is_genetic_started == false:
		var path = str(path_to_genetic + "gen" + str(int(textArea.text)) + ".txt")
		if FileAccess.file_exists(path):
			is_population_dead()
			if is_generation_dead == true:
				is_generation_dead = false
				load_players_data(path)
				await get_tree().create_timer(0.1).timeout
				for i in players:
					i.position = i.respawnPosition
					await get_tree().create_timer(0.06).timeout
					i.t = Thread.new()
					i.is_dead = false
					i.t.start(i.loading, Thread.PRIORITY_HIGH)
				is_generation_loaded = true
			else:
				print("GENERATION IS NOT DEAD!!!")
		else:
			print("File does not exist!")
		is_button_just_pressed = false
		
func generate_first_gen_procedure():
	if is_generate_button_just_pressed == true:
		if FileAccess.file_exists(path_to_genetic + "gen1.txt"):
			print("File exits!")
		else:
			is_population_dead()
			if is_generation_dead == true:
				is_generation_dead = false
				if is_living_process_started == false:
					start_living_process()
					is_saving = true
			else:
				print("GENERATION IS NOT DEAD!!!!")
		is_generate_button_just_pressed = false

func mutate(p1):
	print(p1.moves)
	var random_number = randi_range(0,100)
	
	if random_number >= 0 and random_number <= 5:
		var random_index = randi_range(0,len(p1.moves) - 1)
		p1.moves[random_index] = randi_range(0,5)	
		
	print(p1.moves)
	
func start_genetic_procedure():
	if is_genetic_button_just_pressed == true and is_genetic_started == false:
		genetic_iterations = int(textArea.text)
		#print(genetic_iterations)
		if FileAccess.file_exists(path_to_genetic + "gen" + str(gen_last) + ".txt") :
			if genetic_iterations > 0:
				is_population_dead()
				if is_generation_dead == true:
					find_the_best_player_and_generate_population()
					is_genetic_started = true
					is_generation_dead = false
					is_saving = true
					genetic_iterations_saved = genetic_iterations
					gen_last += 1
					overide_conf()
					genetic_iter = 1
					print("GENETIC PROCESS IS STARTING...", "GENETIC ITERATIONS SAVED: ", genetic_iterations_saved)
					start_living_process()
				else:
					print("GENERATION IS NOT DEAD!!!!")
			else:
				print("ITERATION NUMBER CAN T BE NEGATIVE!!!!")
		is_genetic_button_just_pressed = false

func start_living_process():
	print("STARTING LIVING PROCESS...")
	is_living_process_started = true
	for i in players:
		i.position = i.respawnPosition
		await get_tree().create_timer(0.05).timeout
		i.t = Thread.new()
		i.is_dead = false
		i.t.start(i.life, Thread.PRIORITY_HIGH)

func check_if_moves_are_empty():
	for i in players:
		if i.moves.is_empty() == true:
			player_moves_is_empty_counter += 1
		else:
			player_moves_is_empty_counter = 0
		if player_moves_is_empty_counter == len(players):
			arrays_are_empty = true

func compare_p1_p2_reward(a, b):
	if a.reward > b.reward:
		return true
	return false

func find_the_best_player_and_generate_population():
	load_players_data(path_to_genetic + "gen" + str(gen_last) + ".txt")
	players.sort_custom(compare_p1_p2_reward)
	
	var steps = gen_population / 2
	var index = 0
	var best_players_move_array = players[0].moves
	var best_players_move_array2 = players[1].moves

	for i in range(0, steps):
		players[index].moves  = best_players_move_array.duplicate()
		for pop_counter in range(i,steps):
			players[index].moves.pop_back()
		index += 1
		
	for i in range(steps, len(players)):
		players[index].moves  = best_players_move_array.duplicate()
		for pop_counter in range(0,randi_range(1,4)):
			players[index].moves.pop_back()
		index += 1
		
	print("NEW POPULATION IS: ")
	for i in players:
		i.reward = 0
		print(i.moves)
		
		


func learn():
	await get_tree().create_timer(1).timeout

	while true:
		generate_first_gen_procedure()
		load_generation_procedure()
		start_genetic_procedure()
		
		is_population_dead()
		if is_generation_dead == true:
			if is_saving == true:
				save_players_data(gen_last)
				await get_tree().create_timer(1).timeout
				is_saving = false
			if is_genetic_started == true:
				print("GENETIC ITER IS ", genetic_iter)
				get_tree().create_timer(0.1).timeout
				if genetic_iter < genetic_iterations_saved:
					is_generation_dead = false
					find_the_best_player_and_generate_population()
					await get_tree().create_timer(1).timeout
					start_living_process()
					gen_last += 1
					overide_conf()
					is_saving = true
					genetic_iter += 1
					
				else:
					get_tree().create_timer(0.1).timeout
					genetic_iter = 0
					is_genetic_started = false
					genetic_iterations_saved = 0
		await get_tree().create_timer(0.01).timeout
	

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
		var red = randf_range(0,1)
		var green = randf_range(0,1)
		var blue = randf_range(0,1)
		p.modulate = Color(red,green,blue)
		players.append(p)
	var t = Thread.new()
	t.start(call,Thread.PRIORITY_HIGH)
	
func _process(_delta):
	pass

