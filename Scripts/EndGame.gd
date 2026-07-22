extends Area2D


func _on_body_entered(body):
	print("XD")
	if body.has_method("respawn"):
		body.respawn()
