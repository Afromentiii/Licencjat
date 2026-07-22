extends CharacterBody2D


const SPEED = 25.0
const JUMP_VELOCITY = -400.0
var is_population_dead = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var directionL = true;
var distance = 0
var spawnPosition : Vector2

func _ready():
	spawnPosition = position
	
func changeDirection():
	self.directionL = !self.directionL

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	is_population_dead = get_parent().get_node("GeneticAlgorithm").is_generation_dead
	
	if is_population_dead == false:
		$AnimatedSprite2D.play("move")
		if directionL:
			$AnimatedSprite2D.flip_h = true
			velocity.x = -1 * SPEED
		else:
			$AnimatedSprite2D.flip_h = false
			velocity.x = 1 * SPEED
	else: 
		position = spawnPosition
		velocity.x = move_toward(velocity.x, 0, SPEED)
		directionL = true
		$AnimatedSprite2D.play("default")
		
	move_and_slide()
	
