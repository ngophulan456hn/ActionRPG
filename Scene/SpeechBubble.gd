extends Node2D

onready var anchor = $Anchor
onready var text_node = $Anchor/RichTextLabel
onready var text_bg = $Anchor/ColorRect
onready var timer = $Timer
onready var tween = $Tween
onready var ninePatchRect = $Anchor/NinePatchRect

const char_time = 0.02
const margin_offset = 4

func _ready():
	visible = false
	
func set_text(text, wait_time = 3):
	visible = true
	#set timer
	timer.wait_time = wait_time
	timer.stop()
	#set text
	text_node.bbcode_text = text
	#set duration
	var duration = text_node.text.length() * char_time
	#set size of speech bubble
	var text_size = text_node.get_font("normal_font").get_string_size(text_node.text)
	text_node.margin_left = margin_offset + margin_offset / 2
	text_node.margin_right = text_size.x + (margin_offset * 2 + margin_offset / 2)
	#set animation
	tween.remove_all()
	tween.interpolate_property(text_node, "percent_visible", 0, 1, duration)
	tween.interpolate_property(ninePatchRect, "margin_right", 0, text_size.x + margin_offset * 2, duration)
	tween.interpolate_property(anchor, "position", Vector2.ZERO, Vector2(-text_size.x/2, 0), duration)
	tween.start()
	
func _on_Tween_tween_all_completed():
	timer.start()

func _on_Timer_timeout():
	visible = false
