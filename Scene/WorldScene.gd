extends Node2D

onready var Player = $YSort/Player
onready var backgroundMusic = $BackgroundMusic
onready var chest = $YSort/Room4/Chest
onready var slimes = $YSort/Room4/Slimes
onready var menuScreen = $CanvasLayer/MenuScreen
onready var inventory = $CanvasLayer/Inventory

const Chest = preload("res://Scene/Chest.tscn")

var first_time = true
var is_playing = false

func _ready():
	randomize()
	chest.visible = false
	if(PlayerStats.get_last_location() != Vector2.ZERO):
		Player.global_position = PlayerStats.get_last_location()
	get_tree().paused = false
	pass
	
func _process(delta):
	if slimes.get_child_count() == 0 and is_instance_valid(chest):
		chest.visible = true
		
func random_position() -> Vector2:
	var screenSize = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rndX = rng.randi_range(0, screenSize.x)
	var rndY = rng.randi_range(0, screenSize.y)
	return Vector2(rndX,rndY)
