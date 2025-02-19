extends CanvasLayer
class_name HUD


func updateSlowdown(slowdown: float, slowdown_seconds: float):
	var slowdownPercent = slowdown / slowdown_seconds * 100
	$AspectRatioContainer/MarginContainer/HBoxContainer/VBoxContainer2/SlowdownBar.value = slowdownPercent

func updateAmmo(i: int):
	$AspectRatioContainer/MarginContainer/HBoxContainer/VBoxContainer2/lblAmmoCountNum.text = str(i)

func updateTargetsLeft(targetsLeft: int, targetsStarting: int):
	var s : String
	if targetsLeft > 0:
		s = str(targetsLeft, "/", targetsStarting)
	else:
		s = "EXIT DOORS OPENED!"
	$AspectRatioContainer/MarginContainer/HBoxContainer/VBoxContainer2/lblTargetsLeftNum.text = s
