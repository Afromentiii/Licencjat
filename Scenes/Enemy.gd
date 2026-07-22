extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var directionL = true;


func _physics_process(delta):
	if directionL:
		velocity.x = -1 * SPEED
	else:
		velocity.x = 1 * SPEED
	move_and_slide()
	


func changeDirection():
	self.directionL = !self.directionL
