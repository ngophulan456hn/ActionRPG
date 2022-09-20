extends Node2D

onready var player = $YSort/Player
onready var backgroundMusic = $BackgroundMusic
onready var menuScreen = $CanvasLayer/MenuScreen
onready var inventory = $CanvasLayer/Inventory
onready var loadingScreen = $CanvasLayer/LoadingScreen
onready var camera2D = $Camera2D

func _ready():
	randomize()
	var last_location = PlayerStats.get_last_location().world
	if last_location != Vector2.ZERO:
		last_location.y += 50
		player.global_position = last_location
	player.connect_camera(camera2D)
	Events.connect("enter_new_room", self, "_on_enter_new_room")
	get_tree().paused = false
	
func random_position() -> Vector2:
	var screenSize = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rndX = rng.randi_range(0, screenSize.x)
	var rndY = rng.randi_range(0, screenSize.y)
	return Vector2(rndX,rndY)
	
func _on_enter_new_room(area):
	var collision_shape = area.get_node("CollisionShape2D")
	var size = collision_shape.shape.extents*2
	var view_size = get_viewport_rect().size * camera2D.zoom
	if size.x < view_size.x:
		size.x = view_size.x
	if size.y < view_size.y:
		size.y = view_size.y
		
	camera2D.limit_top = collision_shape.global_position.y - size.y/2
	camera2D.limit_left = collision_shape.global_position.x - size.x/2
	
	camera2D.limit_bottom = camera2D.limit_top + size.y
	camera2D.limit_right = camera2D.limit_left + size.x
		
func _on_EnterMagicMarket_body_entered(body):
	if body.name == "Player":
		loadingScreen.visible = true
		loadingScreen.start_loading('world', player.global_position, 'MagicMarket')
