extends Area2D

var isOpen = false

func Open():
	isOpen = true

func _on_body_entered(body: Node2D) -> void:
	if isOpen and body.name == "Player":
		body.Win()
