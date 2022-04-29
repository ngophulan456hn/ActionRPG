extends StaticBody2D

onready var idle = $Idle
onready var open = $Open
onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer

#const KeyDrop = preload("res://Scene/KeyDrop.tscn")
#const BombDrop = preload("res://Scene/BombDrop.tscn")

var is_player_close = false
var is_open = false

func _ready():
	animationPlayer.play("Idle")
	
func _input(event):
	if event.is_action_pressed("ui_interact") and is_player_close and not is_open:
		is_open = true
		idle.visible = false
		open.visible = true
		#create_max_heart_drop()
		timer.connect("timeout", self, "queue_free")
		timer.set_wait_time(3)
		timer.start()

#func create_max_heart_drop():
#	var maxHeartDrop = MaxHeartDrop.instance()
#	get_parent().add_child(maxHeartDrop)
#	maxHeartDrop.global_position = global_position

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		is_player_close = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		is_player_close = false
