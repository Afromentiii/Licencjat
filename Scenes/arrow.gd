extends Area2D


var spawn_postion = self.position.x

func _process(delta):
	self.position.x -= 7


func _on_body_entered(body):
		if body.has_method("spike_dmg"):
			body.spike_dmg()
		self.position.x = spawn_postion
