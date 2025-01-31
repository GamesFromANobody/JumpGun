extends AudioStreamPlayer

@export var musicVolume = 50
@export var soundVolume = 50

@export var muteSound = false
@export var muteMusic = false

var tracks = [ 
	preload("res://Import/Audio/Music/Maja Salamon - Menu (GUNZO OST) (Menu) (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Ah, Shoot! (GUNZO OST) (Level 1) (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Need More Ammo! (GUNZO OST) (Level 2) (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Pew Pew (GUNZO OST) (Level 3) (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Gun on the Run (GUNZO OST) (Level 4) (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Blasphemy! (GUNZO OST) (Level 5) (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Gnumzo (GUNZO OST) (Level 6) (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Gnomed (GUNZO OST) (Level 6 Easter Egg) (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Layer 1 - Win - Loss - Level Select (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Layer 2 Loss (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Layer 2 Loss (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Layer 2 Loss (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Layer 2 Loss (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Layer 2 Win (LOOP).wav"),
	preload("res://Import/Audio/Music/Maja Salamon - Layer 1 - Win - Loss - Level Select (LOOP).wav"),
	]

func _ready() -> void:
	stream = tracks[0]
	volume_db = -18
	play()
	AudioServer.set_bus_mute(1, true)
	AudioServer.set_bus_mute(3, false)
	AudioServer.set_bus_mute(4, true)
	AudioServer.set_bus_mute(5, true)
	for child in get_children():
		child.play()

func updateVolume():
	volume_db = -18 + (musicVolume - 50) * 0.5
	for child in get_children():
		child.volume_db = -18 + (musicVolume - 50) * 0.5
	$PauseBeat.volume_db = -21 + (musicVolume - 50) * 0.5
	#AudioServer.set_bus_volume_db(2, (musicVolume - 50) * 0.5)

func gnome():
	stop()
	for child in get_children():
		child.stop()

func changePitchScale(newScale):
	pitch_scale = newScale
	for child in get_children():
		child.pitch_scale = newScale

func changeTrack(trackID):
	stream  = tracks[trackID]
	play()
	for child in get_children():
		child.play()

func levelReload():
	levelUnpaused()

func levelLoad():
	play()
	for child in get_children():
		child.play()
	levelUnpaused()

func levelWon():
	AudioServer.set_bus_mute(1, true)
	AudioServer.set_bus_mute(3, false)
	AudioServer.set_bus_mute(4, false)
	$PauseWin.play()

func levelLost():
	AudioServer.set_bus_mute(1, true)
	AudioServer.set_bus_mute(3, false)
	AudioServer.set_bus_mute(5, false)
	$PauseLoss.play()

func levelPaused():
	AudioServer.set_bus_mute(1, true)
	AudioServer.set_bus_mute(3, false)

func levelUnpaused():
	AudioServer.set_bus_mute(1, false)
	AudioServer.set_bus_mute(3, true)
	AudioServer.set_bus_mute(4, true)
	AudioServer.set_bus_mute(5, true)
