extends KinematicBody2D

onready var world = get_tree().current_scene
onready var stats = $Stats
onready var PlayerDetectionZone = $PlayerDetectionZone
onready var hurtBox = $Hurtbox
onready var softCollisions = $SoftCollisions
onready var wanderController = $WanderController
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite

enum { IDLE, WANDER, CHASE, RUNAWAY, DEAD}

var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

const MAX_SPEED = 25
const ACCELERATION = 500
const FRICTION = 500
const KNOCKBACK_DISTANCE = 200

export var slime_max_health: int = 2

func _ready():
	stats.set_max_health(slime_max_health)
	stats.set_health(slime_max_health)
	state = pick_random_state([IDLE, WANDER])
	blinkAnimationPlayer.play("Stop")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE: 
			animationPlayer.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_state_and_wander()
				
		WANDER:
			animationPlayer.play("Wander")
			seek_player()
			if wanderController.get_time_left() == 0:
				update_state_and_wander()
			accelerate_toward_point(wanderController.target_position,delta)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_state_and_wander()
				
		CHASE:
			animationPlayer.play("Chase")
			var player = PlayerDetectionZone.player
			if player != null:
				accelerate_toward_point(player.global_position,delta)
			else: 
				state = IDLE
		
		RUNAWAY:
			animationPlayer.play("RunAway")
			var player = PlayerDetectionZone.player
			if player != null:
				run_awway_from_player(player.global_position,delta)
			else: 
				state = IDLE
				
		DEAD:
			animationPlayer.play("Dead")
			yield(get_node("AnimationPlayer"), "animation_finished")		
			queue_free()
	if softCollisions.is_colliding():
		velocity += softCollisions.get_push_vector() * delta * ACCELERATION
	velocity = move_and_slide(velocity)

func accelerate_toward_point(position: Vector2, delta):
	if stats.get_health() == 1:
		state = RUNAWAY
	else:
		var direction = global_position.direction_to(position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		sprite.flip_h = velocity.x < 0

func run_awway_from_player(position: Vector2, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(-direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	
func update_state_and_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,2))

func seek_player():
	if PlayerDetectionZone.can_see_player(): 
		state = CHASE
		
func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * KNOCKBACK_DISTANCE
	stats.set_health(stats.health - area.damage)
	hurtBox.create_hit_effect()
	hurtBox.start_invincibility(0.4)
	
func _on_Stats_no_health():
	state = DEAD
	
func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
