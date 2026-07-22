extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	get_parent().get_parent().genetic_iterations_saved = get_parent().get_parent().genetic_iter
	get_parent().get_node("Console").text += "THE GENETIC PROCESS WILL STOP AT THE END OF THE CURRENT ITERATION. \n"
	disabled = true
