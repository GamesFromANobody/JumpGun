extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("OPENING LINK")
		body.GNOMED()
		queue_free()
