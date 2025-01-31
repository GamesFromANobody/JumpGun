extends Control

var ThingsTheMenuGunSays = [
	"I'm a gun on the run!",
	"Ah, shoot!",
	"I'm still stuck on this stupid screen!",
	"I forgot what I was gonna say...",
	"Howdy!",
	"Lock & Gluger's got nothin' on me! Nothin'!",
	"No! Don't take me back to the gunsmith!",
	"How many of these dumb quotes are they gonna make me say?",
	"*Casually spams '14' while you're still here*",
	"Those monsters nearly made me the BULLET instead!",
	"Those monsters nearly made me a Trebuchet! Hmm...",
	"So anyway, I started blastin'...",
	"Those monsters used to dump me in acid!"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuGunQuoteChange()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func menuGunQuoteChange():
	var i : int
	if(Global.justLaunched == true):
		Global.justLaunched = false
		i = 0
	else:
		i = (randi() % ThingsTheMenuGunSays.size()) - 1
	$CanvasLayer/MenuGun/TheMenuGunSays.set_deferred("text", str('"', ThingsTheMenuGunSays[i], '"'))
	
	
func _on_level_select_pressed() -> void:
	menuGunQuoteChange()
	get_tree().change_scene_to_file("res://Scenes/UI/level_select.tscn")


func _on_options_pressed() -> void:
	menuGunQuoteChange()
	get_tree().change_scene_to_file("res://Scenes/UI/options.tscn")


func _on_credits_pressed() -> void:
	menuGunQuoteChange()
	get_tree().change_scene_to_file("res://Scenes/UI/credits.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
