extends Node2D

onready var animationPlayer = $AnimationPlayer

const ExplosionEffect = preload("res://Scene/ExplosionEffect.tscn")
const HeartDrop = preload("res://Scene/HeartDrop.tscn")

func create_explosion_effect():
	var explosionEffect = ExplosionEffect.instance()
	get_parent().add_child(explosionEffect)
	explosionEffect.global_position = global_position

func _ready():
	animationPlayer.play("GoBoom")

func _on_AnimationPlayer_animation_finished(anim_name):
	create_explosion_effect()
	queue_free()
