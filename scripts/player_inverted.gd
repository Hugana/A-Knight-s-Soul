extends CharacterBody2D

const SPEED = 100.0

@onready var animated_sprite = $AnimatedSprite2D

const JUMP_VELOCITY = 250.0  # Positive jump velocity pushes the character downwards
const inversion = -1

func _physics_process(delta: float) -> void:
	# Add the negative gravity.
	if not is_on_ceiling():  # Treat ceiling like the floor for negative gravity
		velocity.y += get_gravity().y * delta * inversion

	# Handle "downward jump".
	if Input.is_action_just_pressed("jump") and is_on_ceiling():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0 : 
		animated_sprite.flip_h = false
	elif direction < 0 :
		animated_sprite.flip_h = true
		
	if direction:
		velocity.x = -direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Move and slide the character.
	move_and_slide()# Keep upward as the floor normal for negative gravity
