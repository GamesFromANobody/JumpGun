extends CharacterBody2D
class_name MobEnemy

signal mobHit()

const SPEED = 100.0

enum directionEditor { #to make it more managable in editor
	LEFT,
	RIGHT,
	FLYING_UP,
	FLYING_DOWN,
}
@export_group("Behavior") #Groups @exports to the editor
@export var starting_direction : directionEditor
enum states { #State machines help us more easily manage enemy AI
	SLEEPING,
	STATIONARY,
	PATROLLING,
	PATROLLING_TIMER,
	WANDERING_TIMER, #if we want some mobs in the future to walk/fly aimlessly
	TODO_WAKING_UP, #Should sleeping targets wake up from nearby gunshots?
	WANDERING_IDLE,
	TODO_CHASING_PLAYER, #chase player if they get close enough
	TODO_SHOOTING_PLAYER, #if we want mobs that shoot the player upon being alerted/seeing them
	TODO_DYING #If enemies later on have dying animations, they should perform it before queue_free()
}
enum statesEditor { #Ease of access to level creators, only giving them states that they should apply
	SLEEPING,
	STATIONARY,
	PATROLLING,
	PATROLLING_TIMER,
	WANDERING_TIMER,
}
@export var starting_state : statesEditor = statesEditor.PATROLLING
@export_range(0.1, 5, 0.05) var timer = 1.0
@export var walks_off_cliffs = true
@export var TODO_chases_player = false
@export_group("") #Breaks up the grouping in editor
@export_range(0, 5, 0.05) var movement_speed = 1.0


@export var flying = false



var direction : Vector2
var currentState : states

func _ready() -> void:
	currentState = int(starting_state)
	if starting_direction == directionEditor.RIGHT:
		direction = Vector2(1, 0)
	elif starting_direction == directionEditor.LEFT:
		direction = Vector2(-1, 0)
	elif starting_direction == directionEditor.FLYING_UP:
		direction = Vector2(0, -1)
	else:
		direction = Vector2(0, 1)
	if starting_state == states.PATROLLING_TIMER or starting_state == states.WANDERING_TIMER:
		$WanderTimer.wait_time = timer
		$WanderTimer.start()
	
	
	#For when we use the editor to make enemies, this is to prevent accidental fuckups
	if starting_direction == directionEditor.FLYING_UP or starting_direction == directionEditor.FLYING_DOWN:
		assert(flying == true, "You tried to set this mob's starting direction as flying without it being enabled!")
	if walks_off_cliffs == false:
		assert(flying == false, "FLying enemies should never be bound to the ground, turn on walks off cliffs")

func Hit():
	mobHit.emit()
	queue_free()

func _physics_process(delta: float) -> void:
	
	match currentState:
		states.SLEEPING:
			StateSleep()
		states.STATIONARY:
			StateStationary()
		states.PATROLLING:
			StatePatrolling(delta)
		states.PATROLLING_TIMER:
			StatePatrolling(delta)
		states.WANDERING_TIMER:
			StateWandering(delta)
	
	checkCollision()


func checkCollision():
	# If the player is hit, call its Hit() function
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Player":
			collision.get_collider().Hit()


func StateSleep():
	pass #Nothing for now

func StateStationary():
	pass #nothing for now

func StatePatrolling(delta : float):
	# Gravity; I could imagine we'd have enemies that don't mind cliffs,
	# enemies that reverse on cliffs, and moving targets
	if not is_on_floor() and flying == false:
		velocity += get_gravity() * delta
	# Reverse on walls and/or edges
	if walks_off_cliffs == false and \
	($EdgeDetectionLeft.is_colliding() == false or $EdgeDetectionRight.is_colliding() == false):
		direction = -direction
	if is_on_wall() and (starting_direction == directionEditor.LEFT or starting_direction == directionEditor.RIGHT):
		direction = -direction
	
	if (is_on_ceiling() or is_on_floor()) and flying == true:
		direction = -direction
	
	# Determine which direction this mob is moving
	velocity.x = direction.x * SPEED * movement_speed
	if flying == true:
		velocity.y = direction.y * SPEED * movement_speed
	move_and_slide()

func StateWandering(delta):
	StatePatrolling(delta)


func _on_wander_timer_timeout() -> void:
	match currentState:
		states.PATROLLING_TIMER:
			direction = -direction
			$WanderTimer.start()
		states.WANDERING_TIMER:
			direction = Vector2(0, 0)
			currentState = states.WANDERING_IDLE
			$WanderTimer.wait_time = timer * randf_range(0.35, 1.5)
			$WanderTimer.start()
		states.WANDERING_IDLE:
			if flying == true:
				direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
			else:
				direction.x = 1 - (randi_range(0, 1) * 2)
			$WanderTimer.wait_time = timer * randf_range(0.75, 1.2)
			$WanderTimer.start()
			currentState = states.WANDERING_TIMER
		
