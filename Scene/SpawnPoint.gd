extends Node2D

onready var animationPlayer = $AnimationPlayer


func _ready():
	animationPlayer.play("Idle")
	
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		PlayerStats.set_spawn_position(self.global_position)
		animationPlayer.play("Spawn")


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		animationPlayer.play("Idle")

