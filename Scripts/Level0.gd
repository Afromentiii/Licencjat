extends Node2D

@export var spawnPos = Vector2(-607.751,-4.086)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		for i in get_node("GeneticAlgorithm").players:
			if i.t.is_started() == true:
				i.t.wait_to_finish()
		get_node("GeneticAlgorithm").t.wait_to_finish()		
		get_tree().change_scene_to_packed(load("res://GUI/Levels.tscn"))
		
	if Input.is_action_just_pressed("Camera_pos_spawn"):
		get_node("MovableCamera").position = spawnPos
