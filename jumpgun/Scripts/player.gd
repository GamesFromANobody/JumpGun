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
	SNIPER,
	SMG,
	LMG,
}
#Gun
var gun_type : ShotTypes = ShotTypes.PISTOL
var gun_model_base : Texture2D = preload("res://Import/Textures/Characters/Pistols/glock18-base.png")
var gun_model_color : Texture2D = preload("res://Import/Textures/Characters/Pistols/glock18-greyscale.png")
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
@export var aim_zooming = true
@export var gun_resource : PlayerGunTypes

var bullet_scene = preload("res://Scenes/Projectiles/bullet.tscn")
var bullet_resource : BulletTypes
var base_bullet_resource : BulletTypes

var casing_scene = preload("res://Scenes/Particles/casing.tscn")

#Control scheme
var prevMouseVelocity : Vector2
var usingController = false

#controls
var recoil = Vector2(-10000, 0)
var torque = 20000

#Slowdown
var gameSpeed = 1.0
var shotCooldown = 0.5
var slowdown : float
var allowSlowdown = true
var isPaused = false
var currentMag : int
#HUD
var HUDLayer : CanvasLayer

func _ready() -> void:
	contact_monitor = true
	if GunSelection.gun_resource != null:
		gun_resource = GunSelection.gun_resource
	if gun_resource != null:
		reloadResource()
	$Gun/LaserSight.self_modulate = Color(1, 0, 0, 0)
	$HUD/PauseMenu.hide()
	slowdown = slowdown_seconds
	currentMag = starting_ammo
	HUDLayer = get_node("HUD")
	updateHUD()
	if $Gun.hframes * $Gun.vframes < 6:
		$Gun/Color.hide()
	$Gun.texture = gun_model_base
	$Gun/Color.texture = gun_model_color
	Engine.time_scale = 1.0
	bullet_resource = base_bullet_resource

#Update the game speed while aiming down sight
func _physics_process(delta: float) -> void:
	TasteTheRainbow()
	#ATTENTION Max speed, this prevents wall collisions
	if abs(linear_velocity.length()) > 1000:
		linear_velocity *= 1000 / linear_velocity.length()
	$Velocity.target_position = linear_velocity.rotated(-rotation) * 0.25
	if isPaused:
		return
	shotCooldown -= delta
	var prevGameSpeed = gameSpeed
	if Input.is_action_pressed("aimSlowdown") and allowSlowdown and slowdown > 0:
		if $GunAnimations.is_playing() == false and $Gun.hframes * $Gun.vframes > 7:
			$GunAnimations.play("Aim_Generic")
		gameSpeed -= delta * 2
		if gameSpeed < max_slowdown:
			gameSpeed = max_slowdown
		
		if usingController == false and aim_zooming == true:
			moveCamera((get_local_mouse_position() - $Camera2D.position) * 0.6, 0.4)
		elif aim_zooming == true:
			var hor = Input.get_axis("controllerLEFT", "controllerRIGHT")
			var ver = Input.get_axis("controllerDOWN", "controllerUP")
			var controllerInput = Vector2(hor * 320, ver * 180)
			print(controllerInput)
			moveCamera(controllerInput.rotated(rotation), 2)
	elif gameSpeed < 1.0:
		gameSpeed += delta * 6
		if gameSpeed > 1.0:
			gameSpeed = 1.0
	else:
		if $GunAnimations.is_playing() == false and $Gun.hframes * $Gun.vframes > 7:
			$GunAnimations.play("Idle_Generic")
		moveCamera(Vector2(0, 0), 0.4)
		slowdown += delta * slowdown_recharge_rate
		if slowdown > slowdown_seconds:
			slowdown = slowdown_seconds
	if prevGameSpeed != gameSpeed:
		Engine.time_scale = gameSpeed
		#$GunAnimations.speed_scale = Engine.time_scale
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
	var dir = 0.0
	
	if hor != 0 or ver != 0:
		usingController = true
	if Input.get_last_mouse_velocity() != prevMouseVelocity:
		usingController = false
	prevMouseVelocity = Input.get_last_mouse_velocity()
	
	if usingController:
		set_angular_velocity((get_angle_to(controllerInput + position)) * -((get_angle_to(controllerInput + position)) -3.14) * 3 * rotation_force)
	else:
		#ATTENTION: trying out a hybrid of the old aiming (for precision) and a new way using constant_torque.
		# the old method was good for precise shots, while the new method allows CW and CCW turning
		# to be more equal.
		# When dir is high, use torque itself to rotate the gun.
		# Lets us still fling ourselves, but with "effort".
		# When dir is low, set the angular velocity as-necessary for more precise aim.
		# This has lower force, however.
		dir = transform.y.dot(position.direction_to(mouseInput))
		if abs(dir) > 0.1:
			constant_torque = dir * torque * rotation_force
		else:
			constant_torque = 0
			set_angular_velocity(dir * 10 * rotation_force)
		#NOTE older code: set_angular_velocity((get_angle_to(mouseInput)) * -((get_angle_to(mouseInput)) -3.14) * 5 * rotation_force)
		#older apply_torque suggestion: #state.apply_torque((get_angle_to(mouseInput)) * -((get_angle_to(mouseInput)) -3.14) * 5 * rotation_force)
	
	#shoot
	if (Input.is_action_just_pressed("shoot") and full_auto == false) or \
	(Input.is_action_pressed("shoot") and full_auto == true): #semi-auto vs full-auto
		if shotCooldown > 0:
			return
		if currentMag > 0:
			shotCooldown = shot_cooldown
			#TODO implemet gunshot sound
			currentMag -= 1
			Shoot()
			#state.apply_force(recoil.rotated(rotation) / gameSpeed * knockback)
			ApplyKnockback(state)
		else:
			$ClickSFX.pitch_scale = Engine.time_scale
			$ClickSFX.play()
		
	updateHUD()

func TasteTheRainbow():
	$Gun/Color.modulate = Color.from_hsv((sin(Time.get_ticks_msec() * 0.002) + 1) * 0.5, 0.74, 0.58, 1.0)


func moveCamera(localLocation : Vector2, smoothing : float):
	var tween = create_tween()
	tween.tween_property($Camera2D, "position", localLocation, smoothing)
	tween.play()


func ApplyKnockback(state : PhysicsDirectBodyState2D):
	var wallReduction = 1.0
	if $Back.is_colliding() and get_contact_count() == 0:
		wallReduction *= ($Back.get_collision_point() - global_position).length() / 100
		print(wallReduction)
	state.apply_force(recoil.rotated(rotation) / gameSpeed * knockback * wallReduction)

func Shoot():
	if $Gun.hframes * $Gun.vframes > 7:
		$GunAnimations.play("Shoot_Generic")
		$ShotSFX.pitch_scale = pow(Engine.time_scale, 0.8)
		$ShotSFX.play(0.1)
	match gun_type:
		ShotTypes.PISTOL:
			ShootPistol()
		ShotTypes.SHOTGUN:
			ShootShotgun()
		ShotTypes.SNIPER:
			ShootSniper()
		ShotTypes.SMG:
			ShootSMG()
		ShotTypes.LMG:
			ShootLMG()
	print("Ammo Left: ", str(currentMag))
	

func spawnCasing():
	var casing = casing_scene.instantiate()
	casing.global_position = $Chamber.global_position
	casing.rotation = rotation
	casing.scale = $Gun.scale
	casing.scaleSet = $Gun.scale * 0.8
	casing.apply_central_impulse(Vector2(0, 3 * -randf_range(100, 120)))
	get_parent().call_deferred("add_child", casing)

func ShootPistol():
	var b = bullet_scene.instantiate() as Bullet
	b.transform = $Muzzle.global_transform
	b.bullet_resource = bullet_resource
	b.LoadResource(bullet_resource)
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
		b.bullet_resource = bullet_resource
		b.LoadResource(bullet_resource)
		get_parent().call_deferred("add_child" ,b)
	print("Ammo Left: ", str(currentMag))

func ShootSniper():
	ShootPistol() #temporary, until we decide if SMG's should have their own bullet models

func ShootSMG():
	ShootPistol() #temporary, until we decide if SMG's should have their own bullet models

func ShootLMG():
	ShootPistol() #temporary, until we decide if SMG's should have their own bullet models



func Hit():
	if god_mode != true:
		print("Player is Hit!")
		#TODO, implement game over screen, possibly adding HP?
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/level_select.tscn")

func reloadAmmo():
	var bReloaded = false as bool
	if currentMag == 0:
		bullet_resource = base_bullet_resource
	if currentMag < max_ammo:
		currentMag = max_ammo
		# question: do we wish for ammo to only be the max or for existing ammo to be preserved?
		print("Ammo refilled!")
		bReloaded = true
	return bReloaded


func reloadResource():
	gun_type = int(gun_resource.gun_type)
	gun_model_base = gun_resource.gun_model_base
	
	$Gun.texture = gun_model_base
	$CollisionBox.polygon = gun_resource.gun_hitbox
	$Muzzle.position = gun_resource.muzzle_location
	$ShotSmoke.position = $Muzzle.position + Vector2(12, 1)
	$Chamber.position = gun_resource.chamber_location
	$Gun.position = gun_resource.sprite_position
	$Gun.scale = gun_resource.sprite_scale
	$Gun/LaserSight.position = gun_resource.laser_location
	$Gun.hframes = gun_resource.frames.x
	$Gun.vframes = gun_resource.frames.y
	if gun_resource.gun_model_colors != null:
		gun_model_color = gun_resource.gun_model_colors
		$Gun/Color.texture = gun_model_color
		$Gun/Color.hframes = gun_resource.frames.x
		$Gun/Color.vframes = gun_resource.frames.y
		$Gun/Color.modulate = gun_resource.gun_color
	else:
		$Gun/Color.hide()
	
	full_auto = gun_resource.full_auto
	shot_cooldown = gun_resource.shot_cooldown
	starting_ammo = gun_resource.starting_ammo
	max_ammo = gun_resource.max_ammo
	if currentMag > max_ammo:
		currentMag = max_ammo
	rotation_force = gun_resource.rotation_force
	
	base_bullet_resource = gun_resource.bullet_resource
	knockback = gun_resource.knockback
	
	max_slowdown = gun_resource.max_slowdown
	slowdown_seconds = gun_resource.slowdown_seconds
	if slowdown > slowdown_seconds:
		slowdown = slowdown_seconds
	slowdown_recharge_rate = gun_resource.slowdown_recharge_rate

func SetBulletResource(resource : BulletTypes, applyToBase : bool):
	bullet_resource = resource
	if applyToBase == true:
		base_bullet_resource = resource



#Update the HUD at the end of processing physics, or upon _ready().
#Rather, later on each of these will be updated only when needed.
func updateHUD():
	if HUDLayer == null:
		HUDLayer = get_node("HUD")
	HUDLayer.updateSlowdown(slowdown, slowdown_seconds)
	HUDLayer.updateAmmo(currentMag)
	HUDLayer.updateTargetsLeft(Global.targetsLeft, Global.targetsStarting)

#Pausing/unpausing Functions
func _on_level_base_pause() -> void:
	isPaused = true
	$HUD/PauseMenu.show()
func _on_level_base_unpause() -> void:
	isPaused = false
	$HUD/PauseMenu.hide()
func _on_resume_btn_pressed() -> void:
	unpause.emit()
func _on_return_btn_pressed() -> void:
	unpause.emit()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/level_select.tscn")
