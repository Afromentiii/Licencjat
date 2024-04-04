extends Area2D


var spawn_postion = self.position.x
var current_distance_travel = 0

func _process(delta):
	if get_parent().get_parent().get_node("GeneticAlgorithm").is_generation_dead == false:
		self.position.x -= 0.75
		current_distance_travel +=  0.75
		
		if current_distance_travel == 300:
			current_distance_travel = 0
			self.position.x = spawn_postion
	else:
		self.position.x = spawn_postion
	
func _on_body_entered(body):
		if body.has_method("blackMatter_dmg"):
			body.blackMatter_dmg()
