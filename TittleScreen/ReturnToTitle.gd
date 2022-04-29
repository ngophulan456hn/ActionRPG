extends Control

onready var musicAndSound = $AudioStreamPlayer

func _on_HSlider_value_changed(value):
	musicAndSound.set_bus_volumn_db(musicAndSound.get_bus_index("Master"), value)

func _on_Back_pressed():
	if (GlobalVariable.get_prev_option_scene() == "MenuScreen"):
		get_tree().change_scene("res://Scene/WorldScene.tscn")
	elif (GlobalVariable.get_prev_option_scene() == "TitleScreen"):
		get_tree().change_scene("res://Scene/TitleScreen.tscn")
