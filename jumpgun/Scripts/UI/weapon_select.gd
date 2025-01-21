extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_select_pistol_pressed() -> void:
	Global.set_character("res://Scenes/player.tscn")
	load_level()


func _on_select_shotgun_pressed() -> void:
	Global.set_character("res://Scenes/player_shotgun.tscn")
	load_level()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/level_select.tscn")


func load_level():
	get_tree().change_scene_to_file(Global.levelSelect)
