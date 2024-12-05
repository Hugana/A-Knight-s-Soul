extends Control

@onready var main_container = $Main
@onready var level_select_container = $LevelSelect
@onready var options_container = $Options
@onready var code = $LevelSelect/TextEdit

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	main_container.visible = true  # Ensure the main container starts visible

# Load the next level
func load_next_level(next_scene_path):
	if next_scene_path != "":
		var next_scene = load(next_scene_path) 
		if next_scene:
			get_tree().change_scene_to_packed(next_scene)  
		else:
			print("Failed to load the next scene!")
	else:
		print("Next scene path is not set!")

# Handle New Game button press
func _on_new_game_pressed() -> void:
	load_next_level("res://scenes/Levels/level_0.tscn")

# Handle Level Select button press
func _on_level_select_pressed() -> void:
	main_container.visible = false  # Hide the main container
	level_select_container.visible = true  # Show the level select container
	options_container.visible = false

# Handle Load button press
func _on_load_pressed() -> void:
	var user_input = code.text  
	if(user_input == "2201"):
		load_next_level("res://scenes/Levels/level_1.tscn")
	elif(user_input == "2006"):
		load_next_level("res://scenes/Levels/level_2.tscn")
	elif(user_input == "2506"):
		load_next_level("res://scenes/Levels/level_3.tscn")
	elif(user_input == "koala"):
		load_next_level("res://scenes/Levels/level_3.tscn")
		

# Handle Back button press
func _on_back_pressed() -> void:
	level_select_container.visible = false  # Hide the level select container
	main_container.visible = true  # Show the main container
	options_container.visible = false

# Handle Quit button press
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_full_screen_pressed() -> void:
	var current_mode = DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		# Set to fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		# Set to windowed
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_options_pressed() -> void:
	level_select_container.visible = false  # Hide the level select container
	main_container.visible = false  # Show the main container
	options_container.visible = true
	


func _on_options_back_pressed() -> void:
	level_select_container.visible = false  # Hide the level select container
	main_container.visible = true  # Show the main container
	options_container.visible = false
