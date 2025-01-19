extends TileMapLayer

var objects = [
	preload("res://Scenes/Objects/target.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Creating Objects")
	for cell in get_used_cells_by_id(0, Vector2i(0, 0)):
		print("Ceating target at " + str(cell)) #create target
		createObject(0, cell)
		set_cell(cell, 0, Vector2i(-1, -1))
	for cell in get_used_cells_by_id(0, Vector2i(1, 0)):
		print("TODO Creating Ammo at " + str(cell))
		set_cell(cell, 0, Vector2i(-1, -1))

func createObject(index, pos):
	var newObj = objects[index].instantiate()
	newObj.position = pos * 16
	add_child(newObj)
