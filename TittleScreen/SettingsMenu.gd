extends Popup

#Video Settings
onready var display_option = $SettingTabs/Video/MarginContainer/VideoSettings/DisplayOptionButton
onready var vsync = $SettingTabs/Video/MarginContainer/VideoSettings/VsyncButton
onready var display_fps = $SettingTabs/Video/MarginContainer/VideoSettings/DisplayFPSButton
onready var max_fps_val = $SettingTabs/Video/MarginContainer/VideoSettings/HBoxContainer/MaxFPSVal
onready var max_fps_slider = $SettingTabs/Video/MarginContainer/VideoSettings/HBoxContainer/MaxFPSSlider
onready var bloom = $SettingTabs/Video/MarginContainer/VideoSettings/BloomButton
onready var brightness = $SettingTabs/Video/MarginContainer/VideoSettings/BrightnessSlider

#Audio Settings
onready var master_vol = $SettingTabs/Audio/MarginContainer/AudioSettings/MasterVolSlider
onready var music_vol = $SettingTabs/Audio/MarginContainer/AudioSettings/MusicVolSlider
onready var sfx_vol = $SettingTabs/Audio/MarginContainer/AudioSettings/SfxVolSlider

#Gameplay Settings
onready var fov_val = $SettingTabs/Gameplay/MarginContainer/GameplaySettings/HBoxContainer/FovVal
onready var fov_slider = $SettingTabs/Gameplay/MarginContainer/GameplaySettings/HBoxContainer/FovSlider
onready var mouse_sens_val = $SettingTabs/Gameplay/MarginContainer/GameplaySettings/HBoxContainer2/MouseSensVal
onready var mouse_sens_slider = $SettingTabs/Gameplay/MarginContainer/GameplaySettings/HBoxContainer2/MouseSensSlider

func _ready():
	display_option.select(1 if SaveSetting.game_setting.fullscreen_on else 0)
	GlobalVariable.toggle_fullscreen(SaveSetting.game_setting.fullscreen_on)
	vsync.pressed = SaveSetting.game_setting.vsync_on
	display_fps.pressed = SaveSetting.game_setting.display_fps
	max_fps_slider.value = SaveSetting.game_setting.max_fpf
	bloom.pressed = SaveSetting.game_setting.bloom_on
	brightness.value = SaveSetting.game_setting.brightness
	
	master_vol.value = SaveSetting.game_setting.master_vol 
	music_vol.value = SaveSetting.game_setting.music_vol 
	sfx_vol.value = SaveSetting.game_setting.sfx_vol 
	
	fov_slider.value = SaveSetting.game_setting.fov
	mouse_sens_slider.value = SaveSetting.game_setting.mouse_sens

func _on_DisplayOptionButton_item_selected(index):
	GlobalVariable.toggle_fullscreen(true if index == 1 else false)


func _on_VsyncButton_toggled(button_pressed):
	GlobalVariable.toggle_vsync(button_pressed)


func _on_DisplayFPSButton_toggled(button_pressed):
	GlobalVariable.toggle_fps_display(button_pressed)


func _on_MaxFPSSlider_value_changed(value):
	GlobalVariable.set_max_fps(value)
	max_fps_val.text = str(value) if value < max_fps_slider.max_value else "Max"

func _on_BloomButton_toggled(button_pressed):
	GlobalVariable.toggle_bloom(button_pressed)


func _on_BrightnessSlider_value_changed(value):
	GlobalVariable.update_brightness(value)


func _on_MasterVolSlider_value_changed(value):
	GlobalVariable.update_vol(0, value)


func _on_MusicVolSlider_value_changed(value):
	GlobalVariable.update_vol(1, value)


func _on_SfxVolSlider_value_changed(value):
	GlobalVariable.update_vol(2, value)


func _on_FovSlider_value_changed(value):
	GlobalVariable.update_fov(value)
	fov_val.text = str(value)


func _on_MouseSensSlider_value_changed(value):
	GlobalVariable.update_mouse_sens(value)
	mouse_sens_val.text = str(value)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = false
