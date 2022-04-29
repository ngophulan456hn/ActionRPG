extends StaticBody2D

export(String, MULTILINE) var SignMessage = "Message"

onready var speechBubble = $SpeechBubble

var is_player_close = false

func _input(event):
	if event.is_action_pressed("ui_interact") and is_player_close:
		speechBubble.set_text(SignMessage)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		is_player_close = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		is_player_close = false
