extends Node2D

@export var path_to_conf: String = "res://Levels/Level0/GeneticAlgorithm0/conf.txt"
@export var path_to_genetic: String = "res://Levels/Level0/GeneticAlgorithm0/"
@export var gen_population: int = 256
@export var gen_last: int = 1

@onready var load_gen_button = $Control/VBoxContainer/Button
@onready var textArea = $Control/VBoxContainer/Button/TextEdit
@onready var generate_first_gen = $Control/VBoxContainer/GenerateFirstGeneration
@onready var start_genetic_algorithm = $Control/VBoxContainer/StartGenetic
@onready var population_label = $Control/Population
@onready var generation_label = $Control/Generation
@onready var gen_reward = $Control/MaxGenReward
@onready var console = $Control/Console
@onready var stopButton = $Control/Stop

var is_generation_dead: bool = true
var was_population_alive: bool = false
var is_generation_loaded: bool = false
var is_button_just_pressed: bool = false
var is_generate_button_just_pressed: bool = false
var is_living_process_started: bool = false
var is_saving: bool = false
var is_genetic_button_just_pressed: bool = false
var is_genetic_started: bool = false

var workers: Array[Thread] = []
var chunks: Array = []
var thread_exit: bool = false

var generation_counter: int = 0
var max_generation_reward: int = 0
var genetic_iterations: int = 0
var genetic_iterations_saved: int = 0
var genetic_iter: int = 0
var players: Array = []

func overide_conf() -> void:
	var conf = FileAccess.open(path_to_conf, FileAccess.WRITE)
	conf.store_line("GENERATION_POPULATION " + str(gen_population))
	conf.store_line("LAST_GENERATION " + str(gen_last))
	conf.close()

func save_players_data(gen: int) -> void:
	console.clear()
	console.text += "SAVING DATA PROCESS... \n"
	
	var file_path = path_to_genetic + "gen" + str(gen) + ".txt"
	var generation = FileAccess.open(file_path, FileAccess.WRITE)
	
	generation_counter += 1
	generation_label.text = "GEN COUNT: " + str(generation_counter)
	
	players.sort_custom(compare_p1_p2_reward)
	max_generation_reward = players[0].reward
	gen_reward.text = "CURRENT GENERATION MAX REWARD: " + str(max_generation_reward)
	
	for p in players:
		console.text += "Player id is: %d Reward is: %d Executed moves are: %s\n" % [p.playerID, p.reward, str(p.moves)]
		var line = str(p.reward) + " "
		for m in p.moves:
			line += str(m) + " "
		generation.store_line(line)
		
		p.moves.clear()
		p.reward = 0
	
	generation.close()

func load_players_data(path: String) -> void:
	if not FileAccess.file_exists(path):
		console.text += "FILE DOES NOT EXIST!!! \n"
		return
		
	console.text += "LOADING DATA PROCESS... \n"
	var generation = FileAccess.open(path, FileAccess.READ)
	var index = 0
	
	while not generation.eof_reached():
		var line = generation.get_line()
		var splited_line = line.split(" ")
		
		for i in range(1, len(splited_line) - 1):
			players[index].moves.append(int(splited_line[i]))

		if index < len(players):
			players[index].reward = int(splited_line[0])
			index += 1
			
	generation.close()

func update_population_dead() -> void:
	var any_alive = false
	for p in players:
		if not p.is_dead:
			any_alive = true
			break
			
	if any_alive:
		is_generation_dead = false
		was_population_alive = true
	else:
		if was_population_alive:
			is_generation_dead = true
			was_population_alive = false

func load_generation_procedure() -> void:
	if not (is_button_just_pressed and not is_genetic_started):
		return
		
	is_button_just_pressed = false
	var path = path_to_genetic + "gen" + str(int(textArea.text)) + ".txt"
	
	if not FileAccess.file_exists(path):
		console.text += "FILE DOES NOT EXIST!!! \n"
		return
		
	update_population_dead()
	if not is_generation_dead:
		console.text += "GENERATION IS NOT DEAD!!! \n"
		return
		
	load_gen_button.disabled = true
	is_generation_dead = false
	console.clear()
	load_players_data(path)
	
	for p in players:
		console.text += "Player id is: %d Reward is: %d Executed moves are: %s\n" % [p.playerID, p.reward, str(p.moves)]
	
	await get_tree().create_timer(gen_population * 0.1 / 2).timeout
	
	for p in players:
		p.position = p.respawnPosition
		p.is_dead = false
		p.start_replaying_loaded(Time.get_ticks_msec())		
		
	is_generation_loaded = true

func generate_first_gen_procedure() -> void:
	if not is_generate_button_just_pressed:
		return
		
	is_generate_button_just_pressed = false
	
	if FileAccess.file_exists(path_to_genetic + "gen1.txt"):
		print("File exits!")
		return
		
	update_population_dead()
	if not is_generation_dead:
		console.text += "GENERATION IS NOT DEAD!!! \n"
		return
		
	generate_first_gen.disabled = true
	start_genetic_algorithm.disabled = false
	load_gen_button.disabled = false
	is_generation_dead = false
	
	if not is_living_process_started:
		start_living_process()
		is_saving = true

func start_genetic_procedure() -> void:
	if not (is_genetic_button_just_pressed and not is_genetic_started):
		return
		
	is_genetic_button_just_pressed = false
	genetic_iterations = int(textArea.text)
	
	if not FileAccess.file_exists(path_to_genetic + "gen" + str(gen_last) + ".txt"):
		return
		
	if genetic_iterations <= 0:
		console.text += "ITERATION NUMBER CAN T BE NEGATIVE!!!! \n"
		return
		
	update_population_dead()
	if not is_generation_dead:
		console.text += "GENERATION IS NOT DEAD!!! \n"
		return
		
	start_genetic_algorithm.disabled = true
	console.clear()
	find_the_best_player_and_generate_population()
	
	is_genetic_started = true
	is_generation_dead = false
	is_saving = true
	genetic_iterations_saved = genetic_iterations
	gen_last += 1
	overide_conf()
	genetic_iter = 1
	
	console.text += "GENETIC PROCESS IS STARTING... GENETIC ITERATIONS SAVED: " + str(genetic_iterations_saved) + "\n"
	load_gen_button.disabled = true
	stopButton.disabled = false
	start_living_process()

func start_living_process() -> void:
	console.text += "LIVING PROCESS IS STARTING... \n"
	is_living_process_started = true
	
	await get_tree().create_timer(gen_population * 0.15 / 2).timeout
	
	for p in players:
		p.reward = 0
		p.position = p.respawnPosition
		p.is_dead = false
		p.start_living(Time.get_ticks_msec())

func compare_p1_p2_reward(a, b) -> bool:
	return a.reward > b.reward

func find_the_best_player_and_generate_population() -> void:
	load_players_data(path_to_genetic + "gen" + str(gen_last) + ".txt")
	players.sort_custom(compare_p1_p2_reward)
	
	var steps = gen_population / 2
	var index = 0
	var best_players_move_array = players[0].moves

	for i in range(steps):
		players[index].moves = players[i].moves.duplicate()
		for pop_counter in range(randi_range(1, 3)):
			players[index].moves.pop_back()
		index += 1
		
	for i in range(steps):
		players[index].moves = best_players_move_array.duplicate()
		for pop_counter in range(randi_range(1, 3)):
			players[index].moves.pop_back()
		index += 1
		
func learn() -> void:
	await get_tree().create_timer(1).timeout

	while true:
		generate_first_gen_procedure()
		load_generation_procedure()
		start_genetic_procedure()
		
		update_population_dead()
		if is_generation_dead:
			if is_generation_loaded:
				load_gen_button.disabled = false
				is_generation_loaded = false
				
			if is_saving:
				save_players_data(gen_last)
				await get_tree().create_timer(0.5).timeout
				is_saving = false
				
			if is_genetic_started:
				await get_tree().create_timer(0.1).timeout
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
					genetic_iter = 0
					is_genetic_started = false
					genetic_iterations_saved = 0
					start_genetic_algorithm.disabled = false
					load_gen_button.disabled = false
					stopButton.disabled = true
					
		await get_tree().create_timer(0.01).timeout

func set_player_configuration(p, i: int) -> void:
	p.position = get_parent().spawnPos
	p.respawnPosition = get_parent().spawnPos
	p.playerID = i
	p.get_node("Index").text = str(i)
	p.is_dead = true
	p.modulate = Color(randf(), randf(), randf())
	players.append(p)

func _ready() -> void:
	start_genetic_algorithm.disabled = true
	load_gen_button.disabled = true
	
	if FileAccess.file_exists(path_to_conf):
		var output = []
		var output2 = []
		OS.execute("wmic", ["cpu", "get", "NumberOfLogicalProcessors"], output)
		var text = output[0].split("\n")

		OS.execute("wmic", ["cpu", "get", "NumberOfCores"], output2)
		var text2 = output2[0].split("\n")

		gen_population = 312
		
		var conf = FileAccess.open(path_to_conf, FileAccess.WRITE)
		conf.store_line("GENERATION_POPULATION " + str(gen_population))
		conf.store_line("LAST_GENERATION " + str(gen_last))
		conf.close()
		
		generation_label.text = "GEN COUNT: " + str(generation_counter)
		population_label.text = "GENERATION POPULATION: " + str(gen_population)
		gen_reward.text = "CURRENT GENERATION MAX REWARD: " + str(max_generation_reward)
		
		var counter = 1
		var dir = DirAccess.open(path_to_genetic)
		while FileAccess.file_exists(path_to_genetic + "gen" + str(counter) + ".txt"):
			dir.remove(path_to_genetic + "gen" + str(counter) + ".txt")
			counter += 1
	
	for i in range(gen_population):
		var p = preload("res://Entities/Player/player.tscn").instantiate()
		get_parent().call_deferred("add_child", p)
		set_player_configuration(p, i)
		
	var cores = OS.get_processor_count()
	if cores < 1: cores = 4
	
	for i in range(cores):
		chunks.append([])
		
	var index = 0
	for p in players:
		chunks[index].append(p)
		index = (index + 1) % cores
		
	for i in range(cores):
		var t = Thread.new()
		workers.append(t)
		t.start(worker_loop.bind(chunks[i]))
		
	learn()

func worker_loop(chunk: Array) -> void:
	while not thread_exit:
		var current_time = Time.get_ticks_msec()
		for p in chunk:
			p.process_logic(current_time)
		OS.delay_msec(10)

func _exit_tree() -> void:
	thread_exit = true
	for t in workers:
		if t.is_started():
			t.wait_to_finish()
