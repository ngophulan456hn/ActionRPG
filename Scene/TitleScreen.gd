extends Control

onready var buttons = $Menu/CenterRow/Buttons
onready var newGameButton = $Menu/CenterRow/Buttons/NewGame
onready var continueButton = $Menu/CenterRow/Buttons/Continue
onready var fadeIn = $FadeIn
onready var soundEffect = $SoundEffects
onready var setting_menu = $SettingsMenu

var scene_path_to_load 
const SAVEFILE = "res://SaveGame.save"

func _ready():
	SaveSetting.load_setting()
	newGameButton.grab_focus()
	for button in buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load, button.button_name])
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		continueButton.disabled = true
	
func _on_Button_pressed(scene_to_load, button_name):
	soundEffect.stream = load("res://Music and Sounds/Menu Select.wav");
	soundEffect.play();
	match button_name:
		"Setting":
			setting_menu.popup_centered()
		"Continue":
			SaveGame.load_game()
		"Exit":
			get_tree().quit()
		_:
			scene_path_to_load = scene_to_load
			fadeIn.fade_in()
	
func _on_FadeIn_fade_finished():
	get_tree().change_scene(scene_path_to_load)
	
func _input(event):
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		soundEffect.stream = load("res://Music and Sounds/Menu Move.wav");
		soundEffect.play();
	
	
