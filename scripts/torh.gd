extends Node2D

@onready var animated_sprite = $CPUParticles2D

@export var particle_color: Color = Color(255, 0, 0) # Default red color
@export var gravity_strength: int = -600

func _ready() -> void:
	# Set the color of the particles
	animated_sprite.color = particle_color
	
	# Set the gravity. Gravity strength is applied vertically (Y-axis).
	animated_sprite.gravity = Vector2(0, gravity_strength)

func _process(delta: float) -> void:
	pass
