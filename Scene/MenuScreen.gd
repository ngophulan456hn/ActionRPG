extends Control

onready var buttons = $Menu/CenterRow/Buttons
onready var saveButton = $Menu/CenterRow/Buttons/Save
onready var fadeIn = $FadeIn
onready var soundEffect = $SoundEffects
onready var setting_menu = $SettingsMenu

var scene_path_to_load 
var player_position = Vector2(0,0)
var button_focus = false

func _ready():
	for button in buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load, button.button_name])
	
func _on_Button_pressed(scene_to_load, button_name):
	soundEffect.stream = load("res://Music and Sounds/Menu Select.wav");
	soundEffect.play();
	match button_name:
		"Setting":
			setting_menu.popup_centered()
		"Save":
			save_game()
		"Load":
			SaveGame.load_game()
		"Title":
			scene_path_to_load = scene_to_load
			get_tree().paused = false
			fadeIn.fade_in()
	
func _on_FadeIn_fade_finished():
	get_tree().change_scene(scene_path_to_load)
	
func _input(event):
	if visible:
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
			soundEffect.stream = load("res://Music and Sounds/Menu Move.wav")
			soundEffect.play()
		for button in buttons.get_children():
			if button.has_focus():
				button_focus = true
				break
			else:
				button_focus = false
		if not button_focus:
			saveButton.grab_focus()
			button_focus = true
		
func save_game():
	var world_scene = get_tree().get_current_scene().get_name()
	if world_scene == 'WorldScene':
		player_position = get_node("/root/WorldScene/YSort/Player").global_position
	else:
		player_position = get_node("/root/DungeonScene/YSort/Player").global_position
	var game_data = {
		"max_health": PlayerStats.get_max_health(),
		"health": PlayerStats.get_health(),
		"world_scene": world_scene + ".tscn",
		"position": player_position,
		"spawn_position": PlayerStats.get_spawn_position(),
		"pig": false,
		"inventory": PlayerInventory.inventory,
		"hotbar": PlayerInventory.hotbar,
		"equips": PlayerInventory.equips
	}
	SaveGame.save_data(game_data)
	soundEffect.stream = load("res://Music and Sounds/Unpause.wav");
	soundEffect.play();
	visible = !visible
	get_tree().paused = false
