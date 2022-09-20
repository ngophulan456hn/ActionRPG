extends StaticBody2D

onready var gate = $Gate
onready var doorOpen = $Gate/DoorOpen
onready var doorClose = $Gate/DoorClose

onready var loadingScreen = get_node("/root/WorldScene/CanvasLayer/LoadingScreen")
onready var Player = get_node("/root/WorldScene/YSort/Player")

var is_player_close = false
var is_open = false

func _ready():
	gate_idle()
	
func _input(event):
	if event.is_action_pressed("ui_interact") and is_player_close and not is_open:
		is_open = true
		gate_open()
		
func gate_idle():
	gate.visible = true
	doorOpen.visible = false
	doorClose.visible = true

func gate_open():
	gate.visible = true
	doorOpen.visible = true
	doorClose.visible = false

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		is_player_close = true
	if is_player_close and is_open:
		loadingScreen.visible = true
		loadingScreen.start_loading('world', Player.global_position, 'Dungeon')
		
func _on_Area2D_body_exited(body):
	if body.name == "Player":
		is_player_close = false
