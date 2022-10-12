extends KinematicBody2D

export var speed: int = 125

var score : int = 0


func animates_player(direction: Vector2):
	if direction != Vector2.ZERO:
		# Play walk animation
		$Sprite.play("walkdown")
	else:
		# Play idle animation
		$Sprite.play("idle")

func _physics_process(delta):
	# Get player input
	var direction: Vector2
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Apply movement
	var movement = speed * direction * delta
	move_and_collide(movement)
	
	
	
	
	
	position.x=clamp(position.x, 16, get_viewport_rect().size[0]-16)
	position.y = clamp(position.y, 16 , get_viewport_rect().size[1]-16)
	
func _process(delta):
	if(score !=0):
		print_debug(1)
