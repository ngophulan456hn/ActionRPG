extends KinematicBody2D

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

func _ready():
	sprite.frame = 0
	animationPlayer.play("Idle")
