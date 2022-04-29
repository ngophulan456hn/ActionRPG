extends Node

var prev_option_scene = null setget set_prev_option_scene, get_prev_option_scene

signal fps_display(value)
signal bloom_toggle(value)
signal brightness_update(value)
signal fov_update(value)
signal mouse_sens_update(value)

func set_prev_option_scene(scene: String):
	prev_option_scene = scene
	
func get_prev_option_scene() -> String:
	return prev_option_scene

func toggle_fullscreen(value: bool):
	OS.window_fullscreen = value
	#OS.window_size(0,0) set window size
	save_setting("fullscreen_on", value)
	
func toggle_vsync(value: bool):
	OS.vsync_enabled = value
	save_setting("vsync_on", value)
	
func toggle_fps_display(value: bool):
	emit_signal("fps_display", value)
	save_setting("display_fps", value)
	
func set_max_fps(value: int):
	Engine.target_fps = value if value < 500 else 0
	save_setting("max_fpf", value if value < 500 else 0)
	
func toggle_bloom(value: bool):
	emit_signal("bloom_toggle", value)
	save_setting("bloom_on", value)

func update_brightness(value):
	emit_signal("brightness_update", value)
	save_setting("brightness", value)

func update_vol(bus_idx, vol):
	AudioServer.set_bus_volume_db(bus_idx, vol)
	match bus_idx:
		0:
			save_setting("master_vol", vol)
		1:
			save_setting("music_vol", vol)
		2:
			save_setting("sfx_vol", vol)
	
func update_fov(value):
	emit_signal("fov_update", value)
	save_setting("fov", value)
	
func update_mouse_sens(value):
	emit_signal("mouse_sens_update", value)
	save_setting("mouse_sens", value)
	
func save_setting(name: String, value):
	SaveSetting.game_setting[name] = value
	SaveSetting.save_setting()
	
