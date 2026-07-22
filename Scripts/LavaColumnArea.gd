extends Area2D

var is_population_dead = true

func _process(delta):
	is_population_dead = get_parent().get_node("GeneticAlgorithm").is_generation_dead
	if is_population_dead == false:
		$LavaColumnAnimation.play("LavaColumnAnimation")
	else:
		$LavaColumnAnimation.stop()

func _on_body_entered(body):
	if body.has_method("lavaColumn_dmg"):
		body.lavaColumn_dmg()


