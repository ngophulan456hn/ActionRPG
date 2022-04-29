extends ColorRect

onready var animaltionPlayer = $AnimationPlayer

signal fade_finished

func fade_in():
	animaltionPlayer.play("FadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")
