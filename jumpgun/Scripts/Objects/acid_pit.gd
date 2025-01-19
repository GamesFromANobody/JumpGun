extends Area2D
class_name AcidPit


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("Hit"):
		body.Hit()
