extends TextEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_mouse_entered():
	get_parent().get_parent().get_parent().get_node("MovableCamera").is_onto_console = true


func _on_mouse_exited():
	get_parent().get_parent().get_parent().get_node("MovableCamera").is_onto_console = false
