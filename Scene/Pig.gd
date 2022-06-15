extends KinematicBody2D

onready var world = get_tree().current_scene
onready var PlayerDetectionZone = $PlayerDetectionZone
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var speechbubble = $SpeechBubble
onready var timer = $Timer

enum { IDLE, CHASE, DEATH}

var state = IDLE
var player = null
var speak_yet = false
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

const MAX_SPEED = 100
const ACCELERATION = 1000
const FRICTION = 1000

func _ready():
	PlayerStats.connect("no_health", self, "on_player_death")

func _physics_process(delta):
	player = PlayerDetectionZone.player
	seek_player()
	match state:
		IDLE: 
			animationPlayer.play("Idle")		
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		DEATH:
			animationPlayer.play("Dead")
			yield(get_node("AnimationPlayer"), "animation_finished")		
			queue_free()
		CHASE:
			animationPlayer.play("Run")
			if player != null:
				var player_vector = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(player_vector * MAX_SPEED, ACCELERATION * delta)
			else: 
				state = IDLE
			sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func seek_player():
	if state != DEATH and player:
		var player_direction = player.global_position - global_position
		if player_direction.length() > 25: 
			state = CHASE
		else:
			state = IDLE
		SaveGame.game_data.pig = true
	elif not speak_yet:
		speechbubble.set_text("oink")
		speak_yet = true
		timer.start(10)
		SaveGame.game_data.pig = false

func on_player_death():
	if SaveGame.game_data.pig:
		state = DEATH
	
func _on_Timer_timeout():
	speak_yet = false
