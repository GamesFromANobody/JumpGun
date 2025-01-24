extends StaticBody2D
class_name Target

signal targetHit()
var isHit = false

func Hit():
	if isHit == false:
		isHit = true
		targetHit.emit()
		queue_free()
