extends Node2D

@export var area_1: Area2D
@export var area_2: Area2D
@export var plat_part_1 : CPUParticles2D
@export var plat_part_2 : CPUParticles2D
@export var next_scene_path = "text"
@export var current_scene = "text"
@onready var coin = $inversion_Coin

var is_in_area1 = false
var is_in_area2 = false

var can_invert = true



func _process(delta: float) -> void:
	is_in_area1 = false
	is_in_area2 = false
	plat_part_1.emitting = false
	plat_part_2.emitting = false
	if Input.is_action_just_pressed("restart_level"):
		load_level(current_scene)

	if area_1:  
		for body in area_1.get_overlapping_bodies():
			if body is CharacterBody2D: 
				plat_part_1.emitting = true
				is_in_area1 = true  # Update the global variable
				print("1")
	

	if area_2: 
		for body in area_2.get_overlapping_bodies():
			if body is CharacterBody2D:
				plat_part_2.emitting = true
				is_in_area2 = true  # Update the global variable
				print("2")
				
	# Check if both areas are occupied and the player presses the key
	if is_in_area1 and is_in_area2:
		load_level(next_scene_path)

func load_level(next_scene_path):
	if next_scene_path != "":
		var next_scene = load(next_scene_path) 
		if next_scene:
			get_tree().change_scene_to_packed(next_scene)  
		else:
			print("Failed to load the next scene!")
	else:
		print("Next scene path is not set!")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if can_invert:
		coin.visible = false
		body.direction_inversion *= -1
	can_invert = false
