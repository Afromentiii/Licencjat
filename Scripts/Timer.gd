extends Timer

var player : CharacterBody2D
var duration = 0.25

func _ready():
	print("XD")
	self.autostart = true
	self.wait_time = duration
	Input.action_press("jump")

func _on_timeout():
	Input.action_release("jump")
	queue_free()
	print("XD")
