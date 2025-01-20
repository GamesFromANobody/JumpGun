extends Area2D
class_name Ammo

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.reloadAmmo():
			queue_free()
