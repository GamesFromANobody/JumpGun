extends Control

var fileToLoad = "res://Scenes/UI/main_menu.tscn"

var gunResources : Array[PlayerGunTypes] = [
	preload("res://Resources/Player/Resource_player_pistol.tres"),
	preload("res://Resources/Player/Resource_player_shotgun.tres"),
]

var levelList : Array[String] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AspectRatioContainer/GunSelect.hide()
	#$AspectRatioContainer/ItemList.show()
	$AspectRatioContainer/LevelSelect.show()
	$AspectRatioContainer/ItemList.add_item("Return to Main Menu")
	for file in DirAccess.open("res://Scenes/Levels/").get_files():
		print(file)
		$AspectRatioContainer/ItemList.add_item(str(file))
		levelList.append(str(file))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")





func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	print("item list index: ", index)
	if index == 1:
		get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	else:
		fileToLoad = "res://Scenes/Levels/" + levelList[index - 2]
		#if fileToLoad.ends_with(".remap"):
		#	fileToLoad.trim_suffix(".remap")
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
	MusicController.levelLoad()

func _on_weapon_back_pressed() -> void:
	#$AspectRatioContainer/ItemList.show()
	$AspectRatioContainer/LevelSelect.show()
	$AspectRatioContainer/GunSelect.hide()


func _on_lvl_01_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_Enzo02.tscn")


func _on_lvl_02_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/FF00FF_01.tscn")


func _on_lvl_03_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_Enzo01.tscn")


func _on_lvl_04_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_godis_03_noammo.tscn")


func _on_lvl_05_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_grodis_01_aim.tscn")


func _on_lvl_06_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_grodis_02_speed.tscn")
