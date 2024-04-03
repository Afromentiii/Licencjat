extends AnimatableBody2D

var is_population_dead = false

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	is_population_dead = get_parent().get_node("GeneticAlgorithm").is_generation_dead
	if is_population_dead == false:
		$Plat1Animation.play("move")
	else:
		$Plat1Animation.stop()
