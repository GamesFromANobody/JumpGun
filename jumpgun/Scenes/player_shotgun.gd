extends Player
class_name PlayerShotgun

func shoot():
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
