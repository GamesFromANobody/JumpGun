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

var bullet_scene = preload("res://Scenes/bullet.tscn")

var recoil = Vector2(-30000, 0)
var torque = 20000

func _integrate_forces(state):
	# I'm abusing the aimSlowdown for a sec, don't leave it this way.
	if (Input.is_action_pressed("aimSlowdown")):
		# Mouselook
		set_angular_velocity((get_angle_to(get_global_mouse_position())) * -((get_angle_to(get_global_mouse_position())) -3.14) * 5)
	else:
		# Keyboard-based rotations
		var rotation_dir = 0
		
		if Input.is_action_pressed("rotateLeft"):
			rotation_dir -= 1

		if Input.is_action_pressed("rotateRight"):
			rotation_dir += 1
		state.apply_torque(rotation_dir * torque)
		

	#shoot (force alone for now)
	if Input.is_action_just_pressed("shoot"):
		shoot()
		state.apply_force(recoil.rotated(rotation))
		
	
func shoot():
	var b = bullet_scene.instantiate()
	b.transform = $Muzzle.global_transform
	get_parent().call_deferred("add_child" ,b)
	print("shoot!")
