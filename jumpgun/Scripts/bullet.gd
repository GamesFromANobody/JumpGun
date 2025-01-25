extends Area2D
class_name Bullet

# Well we're not shooting blanks, are we?
# Bullet Class


@export var bullet_resource : BulletTypes = preload("res://Resources/Bullets/bullet_01.tres")
var speed = 800.0
var bounces = 0
var piercing_amount = 0
var acceleration = 0
var ignores_slowdown = false
var stops_at_0_speed = false
var explodes = false
var lifetime = 10.0

func _ready() -> void:
	if $RayCast2D.is_colliding():
		bounces = 0

func _physics_process(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()
	speed += acceleration * delta * 100
	if speed < 0 and stops_at_0_speed == true:
		speed = 0
	position += transform.x * speed * delta
	#if $RayCast2D.is_colliding() and bounces > 0:
		#bounces -= 1

func LoadResource(res : BulletTypes):
	speed = res.speed
	bounces = res.bounces
	piercing_amount = res.piercing_amount
	acceleration = res.acceleration
	ignores_slowdown = res.ignores_slowdown
	stops_at_0_speed = res.stops_at_0_speed
	explodes = res.explodes
	lifetime = res.lifetime_seconds
	$AOE/CollisionShape2D.shape.radius = res.explosion_radius

func _on_body_entered(body: Node2D) -> void:
	print("bullet hit: " + body.name)
	bounces -= 1
	if body.has_method("Hit"):
		body.Hit()
		piercing_amount -= 1
		if piercing_amount < 0:
			if explodes == true:
				Explode()
			queue_free()
	elif bounces > 0:
		Bounce()
	else :
		if explodes == true:
			Explode()
		queue_free()

func Explode():
	for body in $AOE.get_overlapping_bodies():
		if body.has_method("Hit"):
			body.Hit()

#NOT DONE, might abandon and implement this inside a "reflection" object
func Bounce():
	var normal = $RayCast2D.get_collision_normal()
	assert(normal != Vector2(0, 0))
	print(normal)
	transform.x = transform.x.bounce(normal)
	##print(rad_to_deg($RayCast2D.get_angle_to($RayCast2D.get_collision_point())))
	#if rad_to_deg($RayCast2D.get_angle_to($RayCast2D.get_collision_point())) < 90:
		#transform.x = Vector2(1, -1) * transform.x
	#if rad_to_deg($RayCast2D.get_angle_to($RayCast2D.get_collision_point())) > 90:
		#transform.x = Vector2(-1, 1) * transform.x
