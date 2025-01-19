extends StaticBody2D

signal targetHit()

func Hit():
	targetHit.emit()
	queue_free()
