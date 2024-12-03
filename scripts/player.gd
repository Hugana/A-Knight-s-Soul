extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0  # Negative for jumping upwards

var isDead = false

@export var deathLabel: Label
@export var dust_particles: CPUParticles2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $Jump_Sound

@export var inversion = 1  

func _physics_process(delta: float) -> void:
	if isDead:
		# If the player is dead, stop all movement
		velocity.x = 0  # Ensure horizontal movement stops
		return  # Skip the rest of the movement logic

	# Add the gravity (multiplied by inversion for normal or inverted gravity)
	if not is_on_floor():
		velocity.y += get_gravity().y * delta * inversion

	# Handle jump (direction depends on inversion)
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_ceiling()):
		if jump_sound:
			jump_sound.play()
		velocity.y = JUMP_VELOCITY * inversion  # Inverted jump direction if necessary

	# Handle horizontal movement
	var direction = Input.get_axis("move_left", "move_right")

	# Flip sprite based on movement direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	animations(direction)
	
	# Set horizontal velocity
	if direction:
		if is_on_floor() or is_on_ceiling():
			dust_particles.emitting = true
		else:
			dust_particles.emitting = false
		if direction == 1:
			dust_particles.direction = Vector2(1 * inversion, 0)
		elif direction == -1:
			dust_particles.direction = Vector2(-1 * inversion, 0)
		velocity.x = direction * SPEED * inversion
	else:
		dust_particles.emitting = false
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	move_and_slide()

	
func animations(direction):
	if isDead:
		return 
	if direction == 0 and (is_on_ceiling() or is_on_floor()):
		animated_sprite.play("idle")
	elif direction != 0 and (is_on_ceiling() or is_on_floor()):
		animated_sprite.play("run")

func _on_player_inverted_body_entered(body: Node2D) -> void:
	if body.is_in_group("collision_tilemap"):
		isDead = true
		
		if deathLabel:  # Ensure deathLabel is assigned
			deathLabel.visible = true  # Make the label visible
		
		animated_sprite.stop()  # Stop the current animation
		animated_sprite.play("death")  # Play the death animation
		print("PLAYER INVERTED Collided with a TileMap in TileGroup!")


func _on_player_normal_body_entered(body: Node2D) -> void:
	if body.is_in_group("collision_tilemap"):
		isDead = true
		
		if deathLabel:  # Ensure deathLabel is assigned
			deathLabel.visible = true  # Make the label visible
		
		animated_sprite.stop()  # Stop the current animation
		animated_sprite.play("death")  # Play the death animation
		print("PLAYER NORMAL Collided with a TileMap in TileGroup!")
