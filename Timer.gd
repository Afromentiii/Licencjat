extends Timer

@export var duration: float = 0.25
var positionBeforeMove
var player : CharacterBody2D
var moves = ["right", "jump", "nothing"]
var move = 0
var feedback = -1

func checkMove():
	if player.position.x > positionBeforeMove and player.healthBar.value == 100:
		player.feedback = 1	

func _ready():
	self.wait_time = duration
	self.autostart = true
	if move == 2:
		pass
	else:
		Input.action_press(moves[move])

func _on_timeout():
	Input.action_release(moves[move])
	checkMove()
	queue_free()
