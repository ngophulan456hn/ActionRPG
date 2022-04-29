extends Node2D

onready var menuScreen = $CanvasLayer/MenuScreen
onready var inventory = $CanvasLayer/Inventory
onready var canvasLayerBlur = $CanvasLayer/MenuScreen/CanvasLayerBlur
onready var backgroundMusic = $BackgroundMusic
onready var soundEffect = $SoundEffects
onready var fadeIn = $CanvasLayer/FadeIn
onready var Player = $YSort/Player

var is_player_close = false

func _ready():
	randomize()
	fadeIn.connect("fade_finished", self, "_on_FadeIn_fade_finished")
	if(PlayerStats.get_last_location() != Vector2.ZERO):
		Player.global_position = PlayerStats.get_last_location()
		
func _on_ExitDungeon_body_entered(body):
	if body.name == "Player":
		fadeIn.fade_in()
		
func _on_FadeIn_fade_finished():
	get_tree().change_scene("res://Scene/WorldScene.tscn")
	

func _on_ExitDungeon_body_exited(body):
	if body.name == "Player":
		is_player_close = false
