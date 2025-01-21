extends Resource
class_name PlayerGunTypes

enum ShotTypes {
	PISTOL,
	SHOTGUN,
	TODO_SNIPER,
	SMG,
	TODO_LMG,
}
@export_group("Gun")
@export var gun_type : ShotTypes = ShotTypes.PISTOL
@export var gun_model : Texture2D = preload("res://Import/Textures/temp-gun.png")
@export var gun_hitbox : PackedVector2Array
@export var muzzle_location : Vector2 = Vector2(14, -5)
@export var full_auto = false
@export_range(0, 3, 0.005) var shot_cooldown = 0.1 #not used in code, shotCooldown is used
@export_range(0, 200, 1.0) var starting_ammo = 18
@export_range(0, 200, 1.0) var max_ammo = 18
@export_range(0, 10, 0.01) var rotation_force : float = 1.0
@export_group("")

@export_group("Bullets")
@export var bullet_model : Texture2D #Eventually replace this with different bullet scenes instead of just textures
@export_range(100, 3000, 100) var bullet_velocity = 800
@export_range(0, 10, 0.01) var knockback : float = 1.0
@export_group("")

@export_group("Aiming")
@export_range(0.05, 1, 0.01) var max_slowdown : float = 0.25
@export_range(0, 15, 0.25) var slowdown_seconds : float = 2.5
@export_range(0, 4, 0.05) var slowdown_recharge_rate : float = 0.25 #0.25 = 4 times longer to recharge than the active duration 
@export_group("")
