extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")


func _on_apply_pressed() -> void:
	match $AspectRatioContainer/HBoxContainer/VBoxContainer/Resolution.selected:
		0:
			DisplayServer.window_set_size(Vector2i(640,480))
		1:
			DisplayServer.window_set_size(Vector2i(1024,768))
		2:
			DisplayServer.window_set_size(Vector2i(1152,648))
		3:
			DisplayServer.window_set_size(Vector2i(1280,720))
		4:
			DisplayServer.window_set_size(Vector2i(1366,768))
		5:
			DisplayServer.window_set_size(Vector2i(1600,900))
		6:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		7:
			DisplayServer.window_set_size(Vector2i(2560,1440))
		8:
			DisplayServer.window_set_size(Vector2i(3840,2160))
	if $AspectRatioContainer/HBoxContainer/VBoxContainer/Fullscreen.button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	MusicController.musicVolume = $AspectRatioContainer/HBoxContainer/VBoxContainer/MusicContainer/VBoxContainer/MusicSlider.value * float(not MusicController.muteMusic)
	MusicController.soundVolume = $AspectRatioContainer/HBoxContainer/VBoxContainer/SoundContainer/VBoxContainer/SoundSlider.value * float(not MusicController.muteSound)
	MusicController.updateVolume()


func _on_mute_sound_toggled(toggled_on: bool) -> void:
	MusicController.muteSound = toggled_on
	MusicController.soundVolume = $AspectRatioContainer/HBoxContainer/VBoxContainer/SoundContainer/VBoxContainer/SoundSlider.value * float(not MusicController.muteSound)
	MusicController.updateVolume()


func _on_mute_music_toggled(toggled_on: bool) -> void:
	MusicController.muteMusic = toggled_on
	MusicController.musicVolume = $AspectRatioContainer/HBoxContainer/VBoxContainer/MusicContainer/VBoxContainer/MusicSlider.value * float(not MusicController.muteMusic)
	MusicController.updateVolume()
