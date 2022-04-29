extends StaticBody2D

onready var doorOpen = $Open
onready var doorClose = $Close

onready var Player = get_node("/root/DungeonScene/YSort/Player")

var is_player_close = false
var is_open = false

func _ready():
	gate_idle()
	
func _input(event):
	if event.is_action_pressed("ui_interact") and is_player_close and not is_open:
		is_open = true
		gate_open()
		
func gate_idle():
	doorOpen.visible = false
	doorClose.visible = true

func gate_open():
	doorOpen.visible = true
	doorClose.visible = false

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		is_player_close = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		is_player_close = false
