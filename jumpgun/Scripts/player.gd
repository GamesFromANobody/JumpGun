extends RigidBody2D
class_name Player
#replace direction to be rotation direction instead.
#Do we aim with mouse or a/d? LEts try them both
#Game speed modifier
#Game over upon touching the ground?
#add pausing

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var knockback : float = 1.0
@export var player_rotation : float = 1.0
@export var max_slowdown : float = 0.25
@export var slowdown_seconds : float = 2.5
@export var slowdown_recharge_rate : float = 0.25 #0.25 = 4 times longer to recharge than the active duration 

var bullet_scene = preload("res://Scenes/bullet.tscn")

#Control scheme
var prevMouseVelocity : Vector2
var usingController = false

#controls
var recoil = Vector2(-30000, 0)
var torque = 20000

#Slowdown
var gameSpeed = 1.0
var slowdown : float
var allowSlowdown = true

func _ready() -> void:
	$Gun/LaserSight.self_modulate = Color(1, 0, 0, 0)
	slowdown = slowdown_seconds

#Update the game speed while aiming down sight
func _physics_process(delta: float) -> void:
	var prevGameSpeed = gameSpeed
	if Input.is_action_pressed("aimSlowdown") and allowSlowdown and slowdown > 0:
		gameSpeed -= delta * 2
		if gameSpeed < max_slowdown:
			gameSpeed = max_slowdown
	elif gameSpeed < 1.0:
		gameSpeed += delta * 6
		if gameSpeed > 1.0:
			gameSpeed = 1.0
	else:
		slowdown += delta * slowdown_recharge_rate
		if slowdown > slowdown_seconds:
			slowdown = slowdown_seconds
	if prevGameSpeed != gameSpeed:
		Engine.time_scale = gameSpeed
		#print(gameSpeed)
		var alpha = (gameSpeed - 0.25) / 0.75 #To correct for game speed being 0.25-1.0
		$Gun/LaserSight.self_modulate = Color(1, 0, 0, 1 - alpha)
	if gameSpeed < 1:
		slowdown -= delta / gameSpeed
		if slowdown < 0:
			allowSlowdown = false
	if Input.is_action_just_released("aimSlowdown") and slowdown < 0.5:
		allowSlowdown = false
	if slowdown > 0.6:
		allowSlowdown = true
	#print(slowdown)

func _integrate_forces(state):

	var hor = Input.get_axis("controllerLEFT", "controllerRIGHT")
	var ver = Input.get_axis("controllerUP", "controllerDOWN")
	var controllerInput = Vector2(hor, ver) * 100
	var mouseInput = get_global_mouse_position()
	
	if hor != 0 or ver != 0:
		usingController = true
	if Input.get_last_mouse_velocity() != prevMouseVelocity:
		usingController = false
	prevMouseVelocity = Input.get_last_mouse_velocity()
	
	if usingController:
		set_angular_velocity((get_angle_to(controllerInput + position)) * -((get_angle_to(controllerInput + position)) -3.14) * 5)
	else:
		set_angular_velocity((get_angle_to(mouseInput)) * -((get_angle_to(mouseInput)) -3.14) * 5)
	
	
		
	
	#shoot (force alone for now)
	if Input.is_action_just_pressed("shoot"):
		shoot()
		state.apply_force(recoil.rotated(rotation) / gameSpeed * knockback)
		
	
func shoot():
	var b = bullet_scene.instantiate()
	b.transform = $Muzzle.global_transform
	get_parent().call_deferred("add_child" ,b)
	print("shoot!")
