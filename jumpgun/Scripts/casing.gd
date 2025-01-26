extends RigidBody2D

var scaleSet = Vector2(1, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale = scaleSet
	


func changeScale(newScale : Vector2):
	scaleSet = newScale

func Hit():
	queue_free()
