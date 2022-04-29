extends Area2D

const HitEffect = preload("res://Scene/HitEffect.tscn")
onready var timer = $Timer

var invinciable = false setget set_invinciable

signal invincibility_started
signal invincibility_ended

func set_invinciable(value: bool):
	invinciable = value
	if invinciable:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration: float):
	if duration > 0:
		set_invinciable(true)
		timer.start(duration)
	else:
		print("Duration start invincibility must be higher than 0")

func create_hit_effect():
	var hitEffect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

func _on_Timer_timeout():
	set_invinciable(false)

func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring",false)

func _on_Hurtbox_invincibility_ended():
	set_deferred("monitoring",true)
