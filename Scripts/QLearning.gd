extends Node2D

@onready var player = get_parent().get_node("Player")
var iter = 0
var states = []
var call = Callable(self, "learn")

func learn():
	var move 
	var time
	while true:
		iter += 1
		move = randi_range(0,2)
		time = randf_range(0.0,0.4)
		player.move(move, time)
		await get_tree().create_timer(time + 0.05).timeout

	
func _ready():
	#var thread = Thread.new()
	#thread.start(call, Thread.PRIORITY_HIGH)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
