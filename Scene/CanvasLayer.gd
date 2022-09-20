extends CanvasLayer

onready var menuScreen = $MenuScreen
onready var menuCanvasLayerBlur = $MenuScreen/CanvasLayerBlur
onready var gameoverScreen = $GameOverScreen
onready var gameoverCanvasLayerBlur = $GameOverScreen/CanvasLayerBlur
onready var loadingScreen = $LoadingScreen
onready var soundEffect = $SoundEffects
onready var inventory = $Inventory
onready var healthUI = $HealthUI
onready var staminaUI = $StaminaUI
onready var fpsDisplay = $FPSdisplay
onready var hotbar = $Hotbar

var holding_item = null

func _ready():
	menuScreen.visible = false
	inventory.visible = false
	gameoverScreen.visible = false
	loadingScreen.visible = false
	PlayerStats.connect("no_health", self, "on_player_death")
		
func _physics_process(delta):
	if loadingScreen.is_loading:
		loadingScreen.visible = true
		show_or_hide_UI()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if inventory.visible:
			inventory.visible = false
			soundEffect.stream = load("res://Music and Sounds/Unpause.wav");
			soundEffect.play();
			get_tree().paused = false	
		else:
			if not menuScreen.visible:
				soundEffect.stream = load("res://Music and Sounds/Pause.wav");
				soundEffect.play();
				get_tree().paused = true
			else:
				soundEffect.stream = load("res://Music and Sounds/Unpause.wav");
				soundEffect.play();
				get_tree().paused = false	
			menuCanvasLayerBlur.visible = !menuScreen.visible
			menuScreen.visible = !menuScreen.visible

	if event.is_action_pressed("ui_inventory"):
		if not inventory.visible:
			soundEffect.stream = load("res://Music and Sounds/Pause.wav");
			soundEffect.play();
			get_tree().paused = true
		else:
			soundEffect.stream = load("res://Music and Sounds/Unpause.wav");
			soundEffect.play();
			get_tree().paused = false
		inventory.visible = !inventory.visible
		inventory.initialize_inventory()
		
	if event.is_action_pressed("scroll_up") or event.is_action_pressed("item_left"):
		PlayerInventory.active_item_scroll_down()
	elif event.is_action_pressed("scroll_down") or event.is_action_pressed("item_right"):
		PlayerInventory.active_item_scroll_up()
		
func on_player_death():
	get_tree().paused = true
	gameoverScreen.visible = true
	gameoverCanvasLayerBlur.visible = true
	
func show_or_hide_UI():
	healthUI.visible != healthUI.visible
	staminaUI.visible != staminaUI.visible
	hotbar.visible != hotbar.visible
	hotbar.show_or_hide_item(!hotbar.visible)
