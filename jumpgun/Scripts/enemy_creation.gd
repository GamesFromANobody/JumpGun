extends TileMapLayer

var enemies = [
	preload("res://Scenes/Objects/target.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Creating Objects")
	for cell in get_used_cells_by_id(0, Vector2i(0, 0)):
		print("Ceating enemy1 at " + str(cell)) #create target
		createObject(0, cell)
		set_cell(cell, 0, Vector2i(-1, -1))


func createObject(index, pos):
	var newObj = enemies[index].instantiate()
	newObj.position = pos * 16
	add_child(newObj)
