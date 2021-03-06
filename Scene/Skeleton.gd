extends KinematicBody2D

onready var world = get_tree().current_scene
onready var stats = $Stats
onready var PlayerDetectionZone = $PlayerDetectionZone
onready var AnimateSprite = $AnimatedSprite
onready var hurtBox = $Hurtbox
onready var softCollisions = $SoftCollisions
onready var wanderController = $WanderController
onready var attackHitbox = $HitboxPivot/AttackHitbox
onready var attackHitboxCollision = $HitboxPivot/AttackHitbox/CollisionShape2D
onready var timer = $Timer

enum { IDLE, WANDER, CHASE, ATTACK, DEAD, REVIVE}

var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var attack_side = Vector2.RIGHT

const MAX_SPEED = 50
const ACCELERATION = 500
const FRICTION = 500
const KNOCKBACK_DISTANCE = 200

export var skeleton_max_health: int = 2

func _ready():
	AnimateSprite.play('Idle')
	stats.set_max_health(skeleton_max_health)
	stats.set_health(skeleton_max_health)
	state = pick_random_state([IDLE, WANDER])
	attackHitboxCollision.disabled = true
	attackHitbox.knockback_vector = attack_side

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE: 
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			AnimateSprite.play('Idle')
			seek_player()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_state_and_wander()
			accelerate_toward_point(wanderController.target_position, delta, false)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_state_and_wander()
				
		CHASE:
			var player = PlayerDetectionZone.player
			if player != null:
				accelerate_toward_point(player.global_position, delta, true)
			else: 
				state = IDLE
				
		ATTACK:
			AnimateSprite.play('Attack')
			attackHitboxCollision.disabled = false
				
	if softCollisions.is_colliding():
		velocity += softCollisions.get_push_vector() * delta * ACCELERATION
	velocity = move_and_slide(velocity)

func accelerate_toward_point(position: Vector2, delta, is_player: bool):
	var direction = global_position.direction_to(position)
	var distance = global_position.distance_to(position)
	if distance < 20 and is_player:
		velocity = Vector2.ZERO
		AnimateSprite.flip_h = direction.x < 0
		if direction.x > 0:
			attackHitbox.knockback_vector = Vector2.RIGHT
		else:
			attackHitbox.knockback_vector = Vector2.LEFT
		state = ATTACK
	else:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		AnimateSprite.flip_h = velocity.x < 0
		AnimateSprite.play('Walk')
	
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
	AnimateSprite.play('Hit')
	hurtBox.create_hit_effect()
	hurtBox.start_invincibility(0.4)
	
func _on_Stats_no_health():
	AnimateSprite.play('Dead')
	state = DEAD

func _on_AnimatedSprite_animation_finished():
	if state == IDLE:
		if wanderController.get_time_left() == 0:
				update_state_and_wander()		
	if state == ATTACK:
		state = CHASE
		attackHitboxCollision.disabled = true
	if state == DEAD:
		timer.start(2)
	if state == REVIVE:
		state == IDLE

func _on_Timer_timeout():
	if state == DEAD:
		AnimateSprite.play('Dead', true)
		state = REVIVE
		
