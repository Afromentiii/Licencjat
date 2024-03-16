extends CharacterBody2D



const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var lastDirection : float = -2
var deaths : int = 0
var respawnPosition = Vector2(10,10)
var direction = 0
var KeyJump


func endGame():
	var menu : PackedScene = preload("res://Scenes/control.tscn")
	get_tree().change_scene_to_packed(menu)
	
	
	

func enemyDMG():
	$healthBar.value -= 30
	velocity.y = -300
	

func lavaColumn_dmg() -> void:
	$healthBar.value -= 40
	velocity.y = -250
	self.position.x -= 80 * direction

	
func blackMatter_dmg() -> void:
	$healthBar.value -= 100

func hugeJump() -> void:
	velocity.y = -650

func respawn() -> void:
	self.position = respawnPosition

func spike_dmg() -> void:
	$healthBar.value -= 10
	velocity.y = JUMP_VELOCITY
	
func lava_dmg() -> void:
	$healthBar.value -= 25
	velocity.y = JUMP_VELOCITY
	
func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	direction = Input.get_axis("left", "right")
	if direction == -1:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("runL")
		lastDirection = -1
	elif direction == 1:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("runR")
		lastDirection = 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if lastDirection == 1:
			$AnimatedSprite2D.play("defaultR")
		else:
			$AnimatedSprite2D.play("defaultL")

	if $healthBar.value <= 0:
		$healthBar.value = 100
		deaths += 1
		%Deaths.text = "Deaths: " + var_to_str(deaths)
		self.respawn()


	move_and_slide()


