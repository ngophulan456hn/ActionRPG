extends Control

onready var label = $Label
func _ready():
	visible = false
	GlobalVariable.connect("fps_display", self, "_on_fps_display")

func _process(delta):
	label.text = "FPS: %s" % [Engine.get_frames_per_second()]

func _on_fps_display(value):
	visible = value
