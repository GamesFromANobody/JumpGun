extends Node

var levelSelect : String
var playerSelect : String
var targetsStarting : int
var targetsLeft : int

func set_level(level_select):
	self.levelSelect = level_select

func set_character(weapon_type):
	self.playerSelect = weapon_type

func update_targets(i, j):
	targetsStarting = j
	targetsLeft = i
