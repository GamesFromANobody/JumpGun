extends Area2D
class_name Bullet

# Well we're not shooting blanks, are we?
# Bullet Class

@export var speed = 800

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	print("bullet hit: " + body.name)
	if body.has_method("Hit"):
		body.Hit()
	queue_free()
