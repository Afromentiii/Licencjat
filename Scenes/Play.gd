extends Button



func _on_pressed():
	var firstLVL : PackedScene = preload("res://Scenes/world.tscn")
	get_tree().change_scene_to_packed(firstLVL)
