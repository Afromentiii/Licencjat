extends Node2D

@export var spawnPos = Vector2(-20,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		for i in get_node("GeneticAlgorithm").players:
			if i.is_dead == false:
				i.t.wait_to_finish()
		get_tree().change_scene_to_packed(load("res://GUI/Levels.tscn"))
