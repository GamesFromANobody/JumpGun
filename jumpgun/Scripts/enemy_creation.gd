@tool
extends TileMapLayer
#WARNING DON'T fuck with anything in _process() _on_changed() and functions called EDITOR
#Actually, Dont fuck with anything at all, talk with me first @tool is quite dangerous here.
var enemies = [
	preload("res://Scenes/Enemies/mob_enemy.tscn"),
	preload("res://Scenes/Enemies/mob_enemy.tscn"),
	preload("res://Scenes/Objects/acid_pit.tscn"),
	preload("res://Scenes/Objects/acid_pit.tscn"),
]

@export var instantiate_enemies = false
var list_of_enemies : Array[MobEnemy] = []
var listOfEnemyCoordinates : Array[Vector2i] = []
var testCooldown = 10.0

func _process(delta: float) -> void:
	testCooldown -= delta
	if not Engine.is_editor_hint(): #if we are not in the editor, return
		return
	if instantiate_enemies == false and list_of_enemies.size() > 0:
		EDITOR_clearInstances()
	if instantiate_enemies == true:
		testCooldown -= delta
		if testCooldown < 0:
			EDITOR_updateInstances()
			testCooldown = 10
	

func EDITOR_clearInstances():
	for child in get_children():
		child.queue_free()
	list_of_enemies.clear()
	listOfEnemyCoordinates.clear()

func EDITOR_updateInstances():
	for cell in get_used_cells_by_id(0, Vector2i(0, 0)): #Ordo ^2, but should be no issue
		if listOfEnemyCoordinates.find(cell) == -1:
			createObject(0, cell)
	var i = 0
	for cord in listOfEnemyCoordinates:
		if get_cell_atlas_coords(cord) == Vector2i(-1, -1):
			listOfEnemyCoordinates.remove_at(i)
			list_of_enemies[i].queue_free()
			list_of_enemies.remove_at(i)
		i += 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint(): #@tool needs this
		listOfEnemyCoordinates.clear()
		list_of_enemies.clear()
		for child in get_children():
			list_of_enemies.append(child)
			listOfEnemyCoordinates.append((Vector2i(child.position) - Vector2i(8, 8)) / 16)
		return
	print("Creating Enemies")
	for cell in get_used_cells_by_id(0, Vector2i(0, 0)):
		print("Creating enemy0 at " + str(cell)) #create target
		if instantiate_enemies == false:
			createObject(0, cell)
		set_cell(cell, 0, Vector2i(-1, -1))
	for cell in get_used_cells_by_id(0, Vector2i(2, 0)):
		print("Creating enemy1 at " + str(cell)) #create target
		createObject(2, cell)
		set_cell(cell, 0, Vector2i(-1, -1))
	for cell in get_used_cells_by_id(0, Vector2i(3, 0)):
		print("Creating enemy1 at " + str(cell)) #create target
		createObject(3, cell)
		set_cell(cell, 0, Vector2i(-1, -1))
	
	#delete all tiles in the set
	for cell in get_used_cells():
		set_cell(cell, 0, Vector2i(-1, -1))


func createObject(index, pos):
	var newObj = enemies[index].instantiate()
	newObj.position = pos * 16 + Vector2i(8, 8)
	if index == 3:
		newObj.rotate(deg_to_rad(90))
	
	add_child(newObj)
	if Engine.is_editor_hint():
		listOfEnemyCoordinates.append(pos)
		list_of_enemies.append(newObj)
		newObj.set_owner(get_tree().get_edited_scene_root())


func _on_changed() -> void:
	print("tiles changed")
