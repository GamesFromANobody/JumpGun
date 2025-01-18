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
var recoil = Vector2(-30000, 0)
var torque = 20000

func _integrate_forces(state):
	
	var rotation_dir = 0
	#handle rotations
	if Input.is_action_pressed("rotateLeft"):
		rotation_dir -= 1

	if Input.is_action_pressed("rotateRight"):
		rotation_dir += 1
		
	#shoot (force alone for now)
	if Input.is_action_just_pressed("shoot"):
		state.apply_force(recoil.rotated(rotation))
		print("shoot!")
	
	state.apply_torque(rotation_dir * torque)
