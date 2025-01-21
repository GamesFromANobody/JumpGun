extends Control

var fileToLoad = "res://Scenes/Levels/level_test.tscn"

var gunResources : Array[PlayerGunTypes] = [
	preload("res://Resources/Player/Resource_player_pistol.tres"),
	preload("res://Resources/Player/Resource_player_shotgun.tres"),
]

var levelList : Array[String] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AspectRatioContainer/GunSelect.hide()
	$AspectRatioContainer/ItemList.show()
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
	fileToLoad = "res://Scenes/Levels/" + levelList[index - 1]
	print(fileToLoad)
	$AspectRatioContainer/ItemList.hide()
	$AspectRatioContainer/GunSelect.show()


func _on_pistol_pressed() -> void:
	GunSelection.gun_resource = gunResources[0]
	get_tree().change_scene_to_file(fileToLoad)

func _on_shotgun_pressed() -> void:
	GunSelection.gun_resource = gunResources[1]
	get_tree().change_scene_to_file(fileToLoad)

func _on_default_weapon_pressed() -> void:
	get_tree().change_scene_to_file(fileToLoad)

func _on_weapon_back_pressed() -> void:
	$AspectRatioContainer/ItemList.show()
	$AspectRatioContainer/GunSelect.hide()
