extends Area2D

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite

var is_player_close = false

func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	#print(sprite.frame)
	pass

func _on_Spikes_body_entered(body):
	if body.name == "Player":
		animationPlayer.play("Action")
		is_player_close = true
		
func _on_Spikes_body_exited(body):
	if body.name == "Player":
		is_player_close = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if not is_player_close:
		animationPlayer.play("Idle")
	else:
		animationPlayer.play("Action")
