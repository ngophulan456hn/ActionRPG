extends KinematicBody2D

onready var world = get_tree().current_scene
onready var stats = $Stats
onready var PlayerDetectionZone = $PlayerDetectionZone
onready var AnimateSprite = $AnimateSprite
onready var hurtBox = $Hurtbox
onready var softCollisions = $SoftCollisions
onready var wanderController = $WanderController
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var speechBubble = $SpeechBubble

var Bat = load("res://Scene/Bat.tscn")
enum { IDLE, WANDER, CHASE}

var state = IDLE
var say_something = false
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

const MAX_SPEED = 50
const ACCELERATION = 500
const FRICTION = 500
const KNOCKBACK_DISTANCE = 200
const BatDeathEffect = preload("res://Scene/BatDeathEffect.tscn")

export var bat_max_health: int = 2

func _ready():
	AnimateSprite.frame = rand_range(0, 4)
	stats.set_max_health(bat_max_health)
	stats.set_health(bat_max_health)
	state = pick_random_state([IDLE, WANDER])
	blinkAnimationPlayer.play("Stop")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE: 
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_state_and_wander()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_state_and_wander()
			accelerate_toward_point(wanderController.target_position,delta)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_state_and_wander()
				
		CHASE:
			var player = PlayerDetectionZone.player
			if player != null:
				if say_something:
					speechBubble.set_text("[color=red]Die!!![/color]")
					say_something = false
				accelerate_toward_point(player.global_position,delta)
			else: 
				state = IDLE
				
	if softCollisions.is_colliding():
		velocity += softCollisions.get_push_vector() * delta * ACCELERATION
	velocity = move_and_slide(velocity)

func accelerate_toward_point(position: Vector2, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	AnimateSprite.flip_h = velocity.x < 0
	
func update_state_and_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,2))

func seek_player():
	if PlayerDetectionZone.can_see_player():
		say_something = true
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
	queue_free()
	var batDeathEffect = BatDeathEffect.instance()
	get_parent().add_child(batDeathEffect)
	batDeathEffect.global_position = global_position

func spawn_bat(number: int):
	for i in number:
		var bat = Bat.instance()
		world.add_child(bat)
		bat.global_position = global_position

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")




