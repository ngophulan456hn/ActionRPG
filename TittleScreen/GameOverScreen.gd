extends Control

onready var buttons = $Menu/CenterRow/Buttons
onready var continueButton = $Menu/CenterRow/Buttons/Continue
onready var fadeIn = $FadeIn
onready var soundEffect = $SoundEffects

var scene_path_to_load
var button_focus = false

func _ready():
	for button in buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load, button.button_name])
	
func _on_Button_pressed(scene_to_load, button_name):
	soundEffect.stream = load("res://Music and Sounds/Menu Select.wav");
	soundEffect.play();
	match button_name:
		"Continue":
			SaveGame.load_game()
		"Title":
			scene_path_to_load = scene_to_load
			get_tree().paused = false
			fadeIn.fade_in()
		"Exit":
			get_tree().quit()
	
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
			continueButton.grab_focus()
			button_focus = true
