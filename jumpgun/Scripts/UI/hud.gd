extends CanvasLayer
class_name HUD

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func updateSlowdown(slowdown: float, slowdown_seconds: float):
	var slowdownPercent = slowdown / slowdown_seconds * 100
	$AspectRatioContainer/MarginContainer/HBoxContainer/VBoxContainer2/SlowdownBar.value = slowdownPercent

func updateAmmo(i: int):
	$AspectRatioContainer/MarginContainer/HBoxContainer/VBoxContainer2/lblAmmoCountNum.text = str(i)

func updateTargetsLeft(targetsLeft: int, targetsStarting: int):
	var s = str(targetsLeft, "/", targetsStarting)
	$AspectRatioContainer/MarginContainer/HBoxContainer/VBoxContainer2/lblTargetsLeftNum.text = s
