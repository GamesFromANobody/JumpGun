extends RigidBody2D
class_name Player
#replace direction to be rotation direction instead.
#Do we aim with mouse or a/d? LEts try them both
#Game speed modifier
#Game over upon touching the ground?
#add pausing

signal unpause()

enum ShotTypes {
	PISTOL,
	SHOTGUN,
	TODO_SNIPER,
	SMG,
	TODO_LMG,
}
#Gun
var gun_type : ShotTypes = ShotTypes.PISTOL
var gun_model : Texture2D = preload("res://Import/Textures/temp-gun.png")
var full_auto = false
var shot_cooldown = 0.1 #not used in code, shotCooldown is used
var starting_ammo = 18
var max_ammo = 18
var rotation_force : float = 1.0

#Bullets
var bullet_model
var bullet_velocity = 800
var knockback : float = 1.0

#Aiming
var max_slowdown : float = 0.25
var slowdown_seconds : float = 2.5
var slowdown_recharge_rate : float = 0.25 #0.25 = 4 times longer to recharge than the active duration 

@export var god_mode = false
@export var gun_resource : PlayerGunTypes

var bullet_scene = preload("res://Scenes/Projectiles/bullet.tscn")

#Control scheme
var prevMouseVelocity : Vector2
var usingController = false

#controls
var recoil = Vector2(-30000, 0)
var torque = 20000

#Slowdown
var gameSpeed = 1.0
var shotCooldown = 0.5
var slowdown : float
var allowSlowdown = true
var isPaused = false
var currentMag : int

func _ready() -> void:
	if GunSelection.gun_resource != null:
		gun_resource = GunSelection.gun_resource
	if gun_resource != null:
		reloadResource()
	$Gun/LaserSight.self_modulate = Color(1, 0, 0, 0)
	$PauseMenu.hide()
	slowdown = slowdown_seconds
	currentMag = starting_ammo
	#TODO Implement gun model different collision boxes


	$Gun.texture = gun_model

#Update the game speed while aiming down sight
func _physics_process(delta: float) -> void:
	if isPaused:
		return
	shotCooldown -= delta
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
	if isPaused:
		return
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
		set_angular_velocity((get_angle_to(controllerInput + position)) * -((get_angle_to(controllerInput + position)) -3.14) * 5 * rotation_force)
	else:
		set_angular_velocity((get_angle_to(mouseInput)) * -((get_angle_to(mouseInput)) -3.14) * 5 * rotation_force)
	
	
	#shoot
	if (Input.is_action_just_pressed("shoot") and full_auto == false) or \
	(Input.is_action_pressed("shoot") and full_auto == true): #semi-auto vs full-auto
		if shotCooldown > 0:
			return
		if currentMag > 0:
			shotCooldown = shot_cooldown
			#TODO implemet gunshot sound
			currentMag -= 1
			shoot()
			state.apply_force(recoil.rotated(rotation) / gameSpeed * knockback)
		else:
			pass #TODO implement clicking sound
		
	
func shoot():
	match gun_type:
		ShotTypes.PISTOL:
			ShootPistol()
		ShotTypes.SHOTGUN:
			ShootShotgun()
		#ShotTypes.SNIPER:
			#ShootSniper()
		ShotTypes.SMG:
			ShootSMG()
		#ShotTypes.LMG:
			#ShootLMG()

	print("Ammo Left: ", str(currentMag))


func ShootPistol():
	var b = bullet_scene.instantiate() as Bullet
	b.transform = $Muzzle.global_transform
	b.speed = bullet_velocity
	get_parent().call_deferred("add_child" ,b)

func ShootShotgun():
	var spreadAngle = 0.2
	var bArray = [bullet_scene.instantiate() as Bullet,
	 bullet_scene.instantiate() as Bullet,
	 bullet_scene.instantiate() as Bullet,
	 bullet_scene.instantiate() as Bullet]
	for b in bArray:
		b.transform = $Muzzle.global_transform.rotated_local(spreadAngle)
		spreadAngle -= 0.1
		b.speed = bullet_velocity
		get_parent().call_deferred("add_child" ,b)
	print("Ammo Left: ", str(currentMag))

func ShootSniper():
	pass

func ShootSMG():
	ShootPistol() #temporary, until we decide if SMG's should have their own bullet models

func ShootLMG():
	pass



func Hit():
	if god_mode != true:
		print("Player is Hit!")
		#TODO, implement game over screen, possibly adding HP?
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/level_select.tscn")

func reloadAmmo():
	var bReloaded = false as bool
	if currentMag < max_ammo:
		currentMag = max_ammo
		# question: do we wish for ammo to only be the max or for existing ammo to be preserved?
		print("Ammo refilled!")
		bReloaded = true
	return bReloaded


func reloadResource():
	gun_type = int(gun_resource.gun_type)
	gun_model = gun_resource.gun_model
	$Gun.texture = gun_model
	full_auto = gun_resource.full_auto
	shotCooldown = gun_resource.shot_cooldown
	starting_ammo = gun_resource.starting_ammo
	max_ammo = gun_resource.max_ammo
	if currentMag > max_ammo:
		currentMag = max_ammo
	rotation_force = gun_resource.rotation_force
	
	$CollisionBox.polygon = gun_resource.gun_hitbox
	
	bullet_model = gun_resource.bullet_model
	bullet_velocity = gun_resource.bullet_velocity
	knockback = gun_resource.knockback
	
	max_slowdown = gun_resource.max_slowdown
	slowdown_seconds = gun_resource.slowdown_seconds
	if slowdown > slowdown_seconds:
		slowdown = slowdown_seconds
	slowdown_recharge_rate = gun_resource.slowdown_recharge_rate
	
	
	


#Pausing/unpausing Functions
func _on_level_base_pause() -> void:
	isPaused = true
	$PauseMenu.show()
func _on_level_base_unpause() -> void:
	isPaused = false
	$PauseMenu.hide()
func _on_resume_btn_pressed() -> void:
	unpause.emit()
func _on_return_btn_pressed() -> void:
	unpause.emit()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/level_select.tscn")
