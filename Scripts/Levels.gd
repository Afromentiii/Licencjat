extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_quit():
	get_tree().change_scene_to_packed(load("res://GUI/Menu.tscn"))



func _on_level_0_pressed():
	get_tree().change_scene_to_packed(load("res://Levels/Level0/Level0.tscn"))


func _on_level_1_pressed():
	get_tree().change_scene_to_packed(load("res://Levels/Level0/Level1.tscn"))
