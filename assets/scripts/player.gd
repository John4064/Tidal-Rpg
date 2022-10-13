extends KinematicBody2D

export var speed: int = 125
export var dmg = 15
export var hp = 45
export var health_regeneration = 1
var score : int = 0
var last_direction = Vector2(0, 1)
var attack_playing = false



func _on_AnimatedSprite_animation_finished():
	attack_playing = false

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"

func animates_player(direction: Vector2):
	if direction != Vector2.ZERO:
		# update last_direction
		last_direction = direction

		# Choose walk animation based on movement direction
		#var animation = get_animation_direction(last_direction) + "run"
		var animation = "run"
		# Play the walk animation
		$AnimatedSprite.frames.set_animation_speed(animation, 2 + 8 * direction.length())
		#Shit code
		if(get_animation_direction(direction) == "right"):
			get_node( "AnimatedSprite" ).set_flip_h( false )
		elif(get_animation_direction(direction) == "left"):
			get_node( "AnimatedSprite" ).set_flip_h( true )
		$AnimatedSprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = "idle"
		$AnimatedSprite.play(animation)

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
	if attack_playing:
		movement = 0.3 * movement
	move_and_collide(movement)

	position.x=clamp(position.x, 16, get_viewport_rect().size[0]-16)
	position.y = clamp(position.y, 16 , get_viewport_rect().size[1]-16)
	# Animate player based on direction
	if not attack_playing:
		animates_player(direction)

	
func _input(event):
	if event.is_action_pressed("attack1"):
		attack_playing = true
		var animation = "attack"
		$AnimatedSprite.play(animation)
	
func _process(delta):
	if(score !=0):
		print_debug(1)





