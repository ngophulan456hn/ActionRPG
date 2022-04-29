extends Node

const SAVEFILE = "res://UserSetting.save"

var game_setting = {}

func _ready():
	load_setting()

func load_setting():
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		game_setting = {
			"fullscreen_on": false,
			"vsync_on": false,
			"display_fps": false,
			"max_fpf": 0,
			"bloom_on": false,
			"brightness": 1,
			"master_vol": -10,
			"music_vol": -10,
			"sfx_vol": -10,
			"fov": 70,
			"mouse_sens": 0.1		
		}
		save_setting()
	else:
		file.open(SAVEFILE, File.READ)
		game_setting = file.get_var()
		file.close()
		
func save_setting():
	var file = File.new()
	file.open(SAVEFILE, File.WRITE)
	file.store_var(game_setting)
	file.close()
