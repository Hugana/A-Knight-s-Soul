extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0  # Negative for jumping upwards

var isDead = false

@export var deathLabel: Label
@export var dust_particles: CPUParticles2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var audioPlayer = $audioPlayer  # Ensure this is correctly assigned

@export var inversion = 1  
@export var direction_inversion = 1

var rng = RandomNumberGenerator.new()

# Paths to audio files
var jump_sound_path: String = "res://assets/Sounds/jump.mp3"
var death_sound_path: String = "res://assets/Sounds/hitHurt.wav"
var step_sound_path: String = "res://assets/Sounds/step.wav"

var step_interval: float = 0.3  # Time between steps in seconds
var step_timer: float = 0.0    # Tracks elapsed time for steps

func _physics_process(delta: float) -> void:
	if isDead:
		velocity.x = 0  # Stop all movement
		return

	# Add gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta * inversion

	# Handle jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_ceiling()):
		audioPlayer.pitch_scale = 1.0
		play_sound(jump_sound_path)
		velocity.y = JUMP_VELOCITY * inversion

	# Handle horizontal movement
	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		# Play step sound if moving and on the ground
		if is_on_floor():
			step_timer -= delta  # Reduce step timer
			if step_timer <= 0.0:
				play_step_sound()
				step_timer = step_interval  # Reset step timer

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	animations(direction)
	
	# Set horizontal velocity
	if direction:
		velocity.x = direction * SPEED * direction_inversion * inversion
		dust_particles.emitting = is_on_floor() or is_on_ceiling()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		dust_particles.emitting = false

	move_and_slide()

func animations(direction):
	if isDead:
		return
	if direction == 0 and (is_on_ceiling() or is_on_floor()):
		animated_sprite.play("idle")
	elif direction != 0 and (is_on_ceiling() or is_on_floor()):
		animated_sprite.play("run")

func play_step_sound() -> void:
	if not audioPlayer:
		print("Error: audioPlayer node is not available.")
		return

	# Load the step sound
	var step_stream = load(step_sound_path) as AudioStream
	if step_stream:
		audioPlayer.stream = step_stream

		# Randomize pitch
		audioPlayer.pitch_scale = rng.randf_range(0.9, 1) # Randomize pitch between 0.8x and 1.2x
		audioPlayer.play()
	else:
		print("Error: Failed to load step sound at path: ", step_sound_path)

func play_sound(sound_path: String) -> void:
	if not audioPlayer:
		print("Error: audioPlayer node is not available.")
		return

	var audio_stream = load(sound_path) as AudioStream
	if audio_stream:
		audioPlayer.stream = audio_stream
		audioPlayer.play()
	else:
		print("Error: Failed to load sound at path: ", sound_path)

func _on_player_inverted_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("collision_tilemap"):
		isDead = true
		play_sound(death_sound_path)  # Play death sound
		
		if deathLabel:  # Ensure deathLabel is assigned
			deathLabel.visible = true  # Make the label visible
		
		animated_sprite.stop()  # Stop the current animation
		animated_sprite.play("death")  # Play the death animation
		print("PLAYER INVERTED Collided with a TileMap in TileGroup!")


func _on_player_normal_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("collision_tilemap"):
		isDead = true
		play_sound(death_sound_path)  # Play death sound
		
		if deathLabel:  # Ensure deathLabel is assigned
			deathLabel.visible = true  # Make the label visible
		
		animated_sprite.stop()  # Stop the current animation
		animated_sprite.play("death")  # Play the death animation
		print("PLAYER NORMAL Collided with a TileMap in TileGroup!")


	
