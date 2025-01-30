extends AudioStreamPlayer

@export var musicVolume = 50
@export var soundVolume = 50

@export var muteSound = false
@export var muteMusic = false

var tracks = [ 
	preload("res://Import/Audio/Music/Maja Salamon - Cute Gun In-Game Music 1 WIP 7 (LOOP).wav"),
	]

func _ready() -> void:
	stream = tracks[0]
	volume_db = -18
	play()

func updateVolume():
	volume_db = -18 + (musicVolume - 50) * 0.5
	#AudioServer.set_bus_volume_db(2, (musicVolume - 50) * 0.5)
