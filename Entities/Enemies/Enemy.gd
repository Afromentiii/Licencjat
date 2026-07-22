extends CharacterBody2D

const SPEED = 25.0
const JUMP_VELOCITY = -400.0

var is_population_dead: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var directionL: bool = true
var distance: float = 0.0
var spawnPosition: Vector2

func _ready() -> void:
	spawnPosition = position
	
func changeDirection() -> void:
	directionL = not directionL

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	is_population_dead = get_parent().get_node("GeneticAlgorithm").is_generation_dead
	
	if not is_population_dead:
		$AnimatedSprite2D.play("move")
		$AnimatedSprite2D.flip_h = directionL
		velocity.x = -SPEED if directionL else SPEED
	else: 
		position = spawnPosition
		velocity.x = move_toward(velocity.x, 0, SPEED)
		directionL = true
		$AnimatedSprite2D.play("default")
		
	move_and_slide()
