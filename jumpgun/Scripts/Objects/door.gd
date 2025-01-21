extends Area2D

var isOpen = false

func Open():
	isOpen = true

func _on_body_entered(body: Node2D) -> void:
	if isOpen and body.name == "Player":
		get_tree().call_deferred("change_scene_to_file" , "res://Scenes/UI/level_select.tscn")
