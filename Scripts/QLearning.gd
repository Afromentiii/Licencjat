extends Node2D


var iter = 0
var states = []
var call = Callable(self, "learn")
var players = []

func learn():
	await get_tree().create_timer(2).timeout
	while true:
		for i in players:
			var move = randi_range(0,1)
			i.move(move,randf_range(0,0.5))
		await get_tree().create_timer(0.5).timeout


	
func _ready():
	for i in range(0,1):
		var p1 = preload("res://Scenes/player.tscn").instantiate()
		get_parent().call_deferred("add_child",p1)
		p1.position = get_parent().spawnPos
		players.append(p1)

	var t = Thread.new()
	t.start(call,Thread.PRIORITY_HIGH)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
