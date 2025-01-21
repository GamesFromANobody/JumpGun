extends Control

@export var level_path : String = "res://Scenes/Levels/level_test.tscn"

var levelList : Array[String] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for file in DirAccess.open("res://Scenes/Levels/").get_files():
		print(file)
		$AspectRatioContainer/ItemList.add_item(str(file))
		levelList.append(str(file))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")


func _on_testing_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_test.tscn")


func _on_testing_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_grodis1.tscn")



func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var fileToLoad = "res://Scenes/Levels/" + levelList[index - 1]
	print(fileToLoad)
	Global.set_level(fileToLoad)
	get_tree().change_scene_to_file("res://Scenes/UI/weapon_select.tscn")
