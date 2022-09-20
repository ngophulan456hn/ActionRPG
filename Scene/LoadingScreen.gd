extends Control

onready var animationPlayer = $Background/CenterContainer/AnimationPlayer
onready var fadeIn = $FadeIn
onready var background = $Background
onready var timer = $Timer

var is_loading = false
var location = null
var position = null
var scene = null

func _ready():
	background.visible = false
	
func start_loading(loc: String, pos: Vector2, sce: String):
	is_loading = true
	fadeIn.fade_in()
	location = loc
	position = pos
	scene = sce

func _on_FadeIn_fade_finished():
	fadeIn.visible = false
	background.visible = true
	animationPlayer.play("Loading") 
	timer.start()

func _on_Timer_timeout():
	is_loading = false
	on_loading_complete()
	
func on_loading_complete():
	PlayerStats.set_last_location({
		location: position
	})
	get_tree().change_scene("res://Scene/" + scene + ".tscn")
	visible = false
