extends KinematicBody2D

#pub var
export var speed: int = 125
export var dmg = 15
export var health = 45
export var health_max = 45
export var health_regeneration = 1
export var attack_damage = 30
#private var
var tilemap
var animatedPlayer
var score : int = 0
var last_direction = Vector2(0, 1)
var attack_playing = false
# Attack variables
var attack_cooldown_time = 1000
var next_attack_time = 0

#signals
signal player_stats_changed

		
func _ready():
	emit_signal("player_stats_changed", self)
	tilemap = get_tree().root.get_node("Root/TileMap")
	animatedPlayer = get_tree().root.get_node("Root/AnimationPlayer")
	
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
		movement = 0.5 * movement
	
	move_and_collide(movement)
	# Animate player based on direction
	if not attack_playing:
		animates_player(direction)
	# Turn RayCast2D toward movement direction
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 30

	
func _input(event):
	if event.is_action_pressed("attack1"):
		# Check if player can attack
		var now = OS.get_ticks_msec()
		if now >= next_attack_time:
			# What's the target?
			var target = $RayCast2D.get_collider()
			if target != null:
				if target.name.find("Skeleton") >= 0:
					# Skeleton hit!
					target.hit(attack_damage)
			# Play attack animation
			attack_playing = true
			var animation = "attack"
			$AnimatedSprite.play(animation)
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time
		
func _process(delta):
	if(score !=0):
		print_debug(1)
	# Regenerates health
	var new_health = min(health + health_regeneration * delta, health_max)
	if new_health != health:
		health = new_health
		emit_signal("player_stats_changed", self)


func hit(damage):
	health -= damage
	emit_signal("player_stats_changed", self)
	if health <= 0:
		set_process(false)
		animatedPlayer.play("GameOver")
	else:
		$AnimationPlayer.play("Hit")



