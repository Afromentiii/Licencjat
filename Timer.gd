extends Timer

@export var duration: float = 0.25
var positionBeforeMove
var player : CharacterBody2D
var moves = ["right", "jump", "nothing"]
var move = 0
var endPos

func checkMove():
	if endPos > positionBeforeMove and player.healthBar.value == 100:
		player.feedback = 1	

func _ready():
	self.wait_time = duration
	self.autostart = true
	if move == 2:
		pass
	elif move == 1:
		Input.action_press(moves[move])
		Input.action_press(moves[0])
	else:
		Input.action_press(moves[move])

func _on_timeout():
	endPos = player.position.x
	if move == 2:
		pass
	elif move == 1:
		Input.action_release(moves[move])
		Input.action_release(moves[0])
	else:
		Input.action_release(moves[move])
	await get_tree().create_timer(0.5).timeout
	checkMove()
	queue_free()
