extends TileMapLayer

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
	"GARBAGE",
	preload("res://Scenes/door.tscn"),
]
var targetCount = 0
var listOfDoors = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Creating Objects")
	for cell in get_used_cells_by_id(0, Vector2i(0, 0)):
		print("Ceating target at " + str(cell)) #create target
		CreateObject(0, cell)
		targetCount += 1
	
	for cell in get_used_cells_by_id(0, Vector2i(1, 0)):
		print("TODO Creating Ammo at " + str(cell))
	
	for cell in get_used_cells_by_id(0, Vector2i(2, 0)):
		print("Creating Door at " + str(cell))
		listOfDoors.append(CreateObject(2, cell))
		
	
	#delete all tiles in the set
	for cell in get_used_cells():
		set_cell(cell, 0, Vector2i(-1, -1))


func CreateObject(index, pos):
	var newObj = objects[index].instantiate()
	newObj.position = pos * 16 + Vector2i(8, 8)
	if index == 0:
		newObj.targetHit.connect(TargetDestroyed)
	add_child(newObj)
	return newObj

func TargetDestroyed():
	targetCount -= 1
	print("Targets Left: " + str(targetCount))
	if targetCount == 0:
		print("Doors Opening!")
		for door in listOfDoors:
			door.Open()
