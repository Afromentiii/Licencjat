extends Node2D



func _process(delta):
	%Plat1Animation.play("move")
	%Plat2Animation.play("move_plat2")
	%Plat3Animation.play("move3")
	#%Plat4Animation.play("move_4")
	%LavaColumnAnimation.play("LavaColumnAnimation")
	%LavaColumnAnimation2.play("LavaColumnAnimation")
