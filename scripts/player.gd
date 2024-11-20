extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0  # Negative for jumping upwards

@onready var animated_sprite = $AnimatedSprite2D

const inversion = 1  

func _physics_process(delta: float) -> void:
	# Add the gravity (multiplied by inversion for normal or inverted gravity)
	if not is_on_floor():
		velocity.y += get_gravity().y * delta * inversion

	# Handle jump (direction depends on inversion)
	if Input.is_action_just_pressed("jump") and is_on_floor():
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
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Move and slide, with floor normal adjusted by inversion
	move_and_slide()
	
func animations(direction):
		
	if direction == 0:
		animated_sprite.play("idle")
	if direction != 0:
		animated_sprite.play("run")
	
