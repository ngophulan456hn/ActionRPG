extends StaticBody2D

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer

const MaxHeartDrop = preload("res://Scene/MaxHeartDrop.tscn")

var is_player_close = false
var is_open = false

func _ready():
	animationPlayer.play("Idle")
	
func _input(event):
	if event.is_action_pressed("ui_interact") and is_player_close and not is_open:
		is_open = true
		animationPlayer.play("Open")
		create_max_heart_drop()
		yield(get_node("AnimationPlayer"), "animation_finished")
		timer.connect("timeout", self, "queue_free")
		timer.set_wait_time(3)
		timer.start()

func create_max_heart_drop():
	var maxHeartDrop = MaxHeartDrop.instance()
	get_parent().add_child(maxHeartDrop)
	maxHeartDrop.global_position = global_position

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		is_player_close = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		is_player_close = false
