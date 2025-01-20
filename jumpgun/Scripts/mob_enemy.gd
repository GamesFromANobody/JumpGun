extends CharacterBody2D
class_name MobEnemy

signal mobHit()

const SPEED = 100.0

@export var direction = 1

func Hit():
	mobHit.emit()
	queue_free()

func _physics_process(delta: float) -> void:
	# Gravity; I could imagine we'd have enemies that don't mind cliffs,
	# enemies that reverse on cliffs, and moving targets
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Reverse on walls
	if is_on_wall():
		direction = -direction
	# Determine which direction this mob is moving
	velocity.x = direction * SPEED

	move_and_slide()
	
	# If the player is hit, call its Hit() function
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Player":
			collision.get_collider().Hit()
