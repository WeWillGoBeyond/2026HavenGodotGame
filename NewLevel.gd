extends Area2D
@onready var character_body_2d: CharacterBody2D = $"../CharacterBody2D"
@onready var sprite: Sprite2D = $"../Sprite2D"



func _on_body_entered(body: Node2D) -> void:
	if body == character_body_2d:
		get_tree().change_scene_to_file("res://level 3.tscn")
		print("Brother")
