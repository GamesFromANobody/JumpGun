extends Area2D
class_name BulletPowerup

@export var reloads : bool = false
@export var appliesToBase : bool = false
@export_range(0, 6, 1) var bulletType : int = 0
@export var bulletTypes : Array[BulletTypes] = [
	preload("res://Resources/Bullets/bullet_01.tres"),
	preload("res://Resources/Bullets/bullet_explosive_20.tres"),
	preload("res://Resources/Bullets/bullet_fast_slowmo.tres"),
	preload("res://Resources/Bullets/bullet_hover.tres"),
	preload("res://Resources/Bullets/bullet_lifetime_0_2.tres"),
	preload("res://Resources/Bullets/bullet_pierce_5.tres"),
	preload("res://Resources/Bullets/bullet_reverser.tres"),
]

func UpdateTexture(frame : int):
	$Sprite2D.frame = 8 + frame

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if reloads:
			body.reloadAmmo()
		body.SetBulletResource(bulletTypes[bulletType], appliesToBase)
		queue_free()
