extends ColorRect

onready var animaltionPlayer = $AnimationPlayer
export(int) var speed = 0.5 setget set_speed

signal fade_finished

func fade_in():
	animaltionPlayer.play("FadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")
	
func set_speed(value):
	speed = value
	var ap = find_node("AnimationPlayer")
	if ap:
		ap.playback_speed = speed
