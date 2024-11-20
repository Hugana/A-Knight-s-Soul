extends Node2D

@export var area_1: Area2D
@export var area_2: Area2D
@export var next_scene_path = "res://scenes/game_2.tscn"

var is_in_area1 = false
var is_in_area2 = false



func _process(delta: float) -> void:
	is_in_area1 = false
	is_in_area2 = false

	if area_1:  
		for body in area_1.get_overlapping_bodies():
			if body is CharacterBody2D: 
				is_in_area1 = true  # Update the global variable
				print("Player is inside Area2D_1!")

	if area_2: 
		for body in area_2.get_overlapping_bodies():
			if body is CharacterBody2D:
				is_in_area2 = true  # Update the global variable
				print("Player is inside Area2D_2!")
				
	# Check if both areas are occupied and the player presses the key
	if is_in_area1 and is_in_area2:
		load_next_level()

func load_next_level():
	if next_scene_path != "":
		var next_scene = load(next_scene_path) 
		if next_scene:
			get_tree().change_scene_to_packed(next_scene)  
		else:
			print("Failed to load the next scene!")
	else:
		print("Next scene path is not set!")
