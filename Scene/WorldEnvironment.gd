extends WorldEnvironment

func _ready():
	GlobalVariable.connect("bloom_toggle", self, '_on_bloom_toggle')
	GlobalVariable.connect("brightness_update", self, '_on_brightness_update')
	
func _on_bloom_toggle(value):
	environment.glow_enabled = value

func _on_brightness_update(value):
	environment.adjustment_brightness = value

