extends TileMapLayer

#signal targetUpdate(left : int, total : int)

enum targetsMandatory {
	YES,
	NO,
	SOME,
}
## Are targets mandatory
@export var mandatoryTargets : targetsMandatory
## If only some targets are needed, how many?
@export var customTargetsRequried = 0

var objects = [
	preload("res://Scenes/Objects/target.tscn"),
	preload("res://Scenes/Objects/ammo.tscn"),
	preload("res://Scenes/Objects/door.tscn"),
]
var targetCount = 0
var startingTargets = 0
var listOfDoors = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Creating Objects")
	for cell in get_used_cells_by_id(0, Vector2i(0, 0)):
		print("Creating target at " + str(cell)) #create target
		CreateObject(0, cell)
		targetCount += 1
	
	for cell in get_used_cells_by_id(0, Vector2i(1, 0)):
		print("Creating Ammo at " + str(cell))
		CreateObject(1, cell)
	
	for cell in get_used_cells_by_id(0, Vector2i(2, 0)):
		print("Creating Door at " + str(cell))
		listOfDoors.append(CreateObject(2, cell))
		
	
	#delete all tiles in the set
	for cell in get_used_cells():
		set_cell(cell, 0, Vector2i(-1, -1))
	
	# finally, set our starting targets count
	# which will probably lead to removing the local one later on...
	startingTargets = targetCount
	Global.update_targets(targetCount, startingTargets)


func CreateObject(index, pos):
	var newObj = objects[index].instantiate()
	newObj.position = pos * 16 + Vector2i(8, 8)
	if index == 0:
		newObj.targetHit.connect(TargetDestroyed)
	add_child(newObj)
	return newObj

func TargetDestroyed():
	targetCount -= 1
	#targetUpdate.emit(targetCount, startingTargets)
	Global.update_targets(targetCount, startingTargets)
	print("Targets Left: " + str(targetCount))
	if targetCount == 0:
		print("Doors Opening!")
		for door in listOfDoors:
			door.Open()
