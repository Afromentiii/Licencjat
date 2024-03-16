extends Area2D



func _on_body_entered(body):
	if body.has_method("lavaColumn_dmg"):
		body.lavaColumn_dmg()


