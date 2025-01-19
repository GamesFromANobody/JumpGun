extends Node2D
class_name Level
#This node should control pausing and game speed (if we want to change it)
signal pause()
signal unpause()


var isPaused : bool = false
var prevTimeScale = 1.0

@export var player : Player

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
	prevTimeScale = Engine.time_scale
	Engine.time_scale = 0
	pause.emit()
	set_process_input(true)
	print("Pausing")

func Unpause():
	isPaused = false
	Engine.time_scale = prevTimeScale
	unpause.emit()
	print("Unpausing")

func ChangeLevel():
	isPaused = true
