extends Camera2D

# References to the two player nodes
@export var player1: NodePath
@export var player2: NodePath

# Zoom configuration
@export var min_zoom: Vector2 = Vector2(1, 1)  # Closest zoom level (zoomed in)
@export var max_zoom: Vector2 = Vector2(3, 3)  # Farthest zoom level (zoomed out)
@export var distance_threshold: float = 500.0  # Maximum distance for zoom scaling
@export var zoom_dampening: float = 0.5       # Dampening factor for zoom adjustment

func _ready():
	# Ensure the player references are valid
	if not player1 or not player2:
		print("Error: Player paths are not set!")

func _process(delta: float) -> void:
	var p1 = get_node(player1)
	var p2 = get_node(player2)
	
	if p1 and p2:
		# Calculate the midpoint between the two players
		var midpoint = (p1.global_position + p2.global_position) / 2
		global_position = midpoint

		# Calculate the distance between the players
		var distance = p1.global_position.distance_to(p2.global_position)

		# Normalize the distance to a value between 0 and 1
		var normalized_distance = clamp(distance / distance_threshold, 0, 1)

		# Invert the relationship (larger distance = smaller zoom)
		var zoom_factor = 1.0 - pow(normalized_distance, zoom_dampening)

		# Interpolate between min and max zoom using the inverted factor
		zoom = min_zoom.lerp(max_zoom, zoom_factor)
