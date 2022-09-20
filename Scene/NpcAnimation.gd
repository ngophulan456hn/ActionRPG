extends KinematicBody2D

onready var world = get_tree().current_scene
onready var sprite = $Sprite
onready var softCollisions = $SoftCollisions
onready var wanderController = $WanderController
onready var speechBubble = $SpeechBubble
onready var animationPlayer = $AnimationPlayer
onready var PlayerDetectionZone = $PlayerDetectionZone
onready var timer = $Timer

enum { IDLE, WANDER }

var state = IDLE
var say_something = true
var velocity = Vector2.ZERO

const MAX_SPEED = 50
const ACCELERATION = 500
const FRICTION = 500

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	match state:
		IDLE: 
			animationPlayer.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.get_time_left() == 0:
				update_state_and_wander()
				
		WANDER:
			animationPlayer.play("Wander")
			if wanderController.get_time_left() == 0:
				update_state_and_wander()
			accelerate_toward_point(wanderController.target_position,delta)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_state_and_wander()
	
	seek_player()
	if softCollisions.is_colliding():
		velocity += softCollisions.get_push_vector() * delta * ACCELERATION
	velocity = move_and_slide(velocity)

func accelerate_toward_point(position: Vector2, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	
func update_state_and_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,2))
		
func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()	
	
func seek_player():
	if PlayerDetectionZone.can_see_player() and say_something:
		speechBubble.set_text()
		say_something = false
		timer.start(10)

func _on_Timer_timeout():
	say_something = true
