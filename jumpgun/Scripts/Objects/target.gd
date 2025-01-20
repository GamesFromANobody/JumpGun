extends StaticBody2D
class_name Target

signal targetHit()

func Hit():
	targetHit.emit()
	queue_free()
