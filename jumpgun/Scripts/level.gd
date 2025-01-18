extends Node2D
class_name Level
#This node should control pausing and game speed (if we want to change it)
signal pause()
signal unpause()
signal changeGameSpeed(newSpeed : float) #Setter, the recieving node should just apply this value

var isPaused : bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if isPaused == true:
			Unpause()
		else:
			Pause()

func Pause():
	isPaused = true
	pause.emit()

func Unpause():
	isPaused = false
	unpause.emit()

func ChangeLevel():
	pass
