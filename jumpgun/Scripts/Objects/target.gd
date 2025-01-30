extends StaticBody2D
class_name Target

signal targetHit()
var isHit = false

func Hit():
	if isHit == false:
		isHit = true
		targetHit.emit()
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$PopTargetSFX.play() #note: need to get access to the slowmo modifier


func _on_pop_target_sfx_finished() -> void:
	queue_free()
