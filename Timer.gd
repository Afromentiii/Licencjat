extends Timer

@export var duration: float = 0.25
var moves = ["right", "jump", "left", "nothing"]
var move = 0

func _ready():
	self.wait_time = duration
	self.autostart = true
	if move == 3:
		pass
	else:
		Input.action_press(moves[move])

func _on_timeout():
	Input.action_release(moves[move])
	queue_free()
