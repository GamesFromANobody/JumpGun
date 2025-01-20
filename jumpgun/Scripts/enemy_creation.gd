extends TileMapLayer

var enemies = [
	preload("res://Scenes/mob_enemy.tscn"),
	"GARBAGE",
	preload("res://Scenes/Objects/acid_pit.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Creating Enemies")
	for cell in get_used_cells_by_id(0, Vector2i(0, 0)):
		print("Creating enemy0 at " + str(cell)) #create target
		createObject(0, cell)
		set_cell(cell, 0, Vector2i(-1, -1))
	for cell in get_used_cells_by_id(0, Vector2i(2, 0)):
		print("Creating enemy1 at " + str(cell)) #create target
		createObject(2, cell)
		set_cell(cell, 0, Vector2i(-1, -1))
	
	#delete all tiles in the set
	for cell in get_used_cells():
		set_cell(cell, 0, Vector2i(-1, -1))


func createObject(index, pos):
	var newObj = enemies[index].instantiate()
	newObj.position = pos * 16 + Vector2i(8, 8)
	add_child(newObj)
