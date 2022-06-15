extends KinematicBody2D

enum { MOVE, ROLL, ATTACK}

const PlayerHurtSound = preload("res://Scene/PlayerHurtSound.tscn")
const Bomb = preload("res://Scene/Bomb.tscn")
const Pig = preload("res://Scene/Pig.tscn")

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var had_react_save_point = false
var has_call = false

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var swordHitboxCollision = $HitboxPivot/SwordHitbox/CollisionShape2D
onready var hurtBox = $Hurtbox
onready var camera2D = $Camera2D
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var speechBubble = $SpeechBubble
onready var pickupZone = $PickupZone

const MAX_SPEED = 100
const ACCELERATION = 1000
const FRICTION = 1000
const ROLL_SPEED = MAX_SPEED * 1.0
const RECHARGE_ROLL_SPEED = 10


func _ready():
	PlayerStats.connect("no_health", self, "_on_PlayerStats_no_health")
	PlayerStats.set_spawn_position(self.global_position)
	if SaveGame.game_data.position == Vector2(0,0):
		PlayerStats.set_max_health(SaveGame.game_data.max_health)
		PlayerStats.set_health(SaveGame.game_data.health)
	animationTree.active = true
	swordHitboxCollision.disabled = true
	swordHitbox.knockback_vector = roll_vector
	blinkAnimationPlayer.play("Stop")
	spawn_pig_with_player()
	#speechBubble.set_text("Hello and welcome you to my game")
	
func _physics_process(delta):
	if PlayerStats.get_current_stamina() < PlayerStats.get_max_stamina():
		PlayerStats.recharge_saitama(PlayerStats.get_current_stamina() + delta * RECHARGE_ROLL_SPEED)
		
	match state:
		MOVE: 
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)
	
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")	
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("ui_roll"):
		if has_call:
			has_call = false
		state = ROLL
		
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
	
func plant_bomb():
	var bomb = Bomb.instance()
	get_parent().add_child(bomb)
	bomb.global_position = global_position
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func roll_state(delta):
	if PlayerStats.get_current_stamina() > 15:
		velocity = roll_vector * ROLL_SPEED
		#hurtBox.start_invincibility(0.6)
		animationState.travel("Roll")
		move()
	else:
		state = MOVE

func move():
	velocity = move_and_slide(velocity)
	
func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	velocity = Vector2.ZERO
	if not has_call:
		PlayerStats.consume_stamina()
		has_call = true
	state = MOVE
	
func _input(event):
	if event.is_action_pressed("ui_interact"):
#		if pickupZone.item_in_range.size() > 0:
#			var pickup_item = pickupZone.item_in_range.values()[0]
#			pickup_item.pick_up_item(self)
#			pickupZone.item_in_range.erase(pickup_item)
		if PlayerInventory.active_item != null:
			if PlayerInventory.active_item.item_name == "Bomb":
				plant_bomb()

func _on_Hurtbox_area_entered(area):
	PlayerStats.set_health(PlayerStats.get_health() - area.damage)
	hurtBox.start_invincibility(0.6)
	hurtBox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	var percent = randf()
	if PlayerStats.get_health() == 1:
		if (percent <= 0.5):
			speechBubble.set_text("Runnnn!!!")
		else:
			speechBubble.set_text("Reteat!!!")

func _on_PlayerStats_no_health():
	self.global_position = PlayerStats.get_spawn_position()
	PlayerStats.set_max_health(PlayerStats.get_max_health())
	PlayerStats.set_health(PlayerStats.get_max_health())
	spawn_pig_with_player()
	#get_tree().reload_current_scene()
	
func spawn_pig_with_player():
	if SaveGame.game_data.pig:
		var pig = Pig.instance()
		get_parent().add_child(pig)
		pig.global_position = global_position

func _on_RoomDetector_area_entered(area):
	var collision_shape = area.get_node("CollisionShape2D")
	var size = collision_shape.shape.extents*2
	var view_size = get_viewport_rect().size * camera2D.zoom
	if size.x < view_size.x:
		size.x = view_size.x
	if size.y < view_size.y:
		size.y = view_size.y
		
	camera2D.limit_top = collision_shape.global_position.y - size.y/2
	camera2D.limit_left = collision_shape.global_position.x - size.x/2
	
	
	camera2D.limit_bottom = camera2D.limit_top + size.y
	camera2D.limit_right = camera2D.limit_left + size.x
	
func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
