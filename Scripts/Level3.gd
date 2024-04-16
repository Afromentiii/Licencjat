extends Node2D

@export var spawnPos = Vector2(700,0)

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		for i in get_node("GeneticAlgorithm").players:
			if i.t.is_started() == true:
				i.t.wait_to_finish()
		get_node("GeneticAlgorithm").t.wait_to_finish()		
		get_tree().change_scene_to_packed(load("res://GUI/Levels.tscn"))

