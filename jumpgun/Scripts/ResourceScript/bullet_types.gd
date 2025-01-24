extends Resource
class_name BulletTypes

@export_range(100, 3000, 50) var speed = 800
@export_group("Modifiers")
@export var bounces = 0
@export var piercing_amount = 0
@export var acceleration = 0
@export var ignores_slowdown = false
@export var stops_at_0_speed = false
@export_group("")
@export var bullet_texture : Texture2D
@export var hitbox : Shape2D
