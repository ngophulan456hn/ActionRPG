extends Area2D

var item_in_range = {}

func _ready():
	pass # Replace with function body.

func _on_PickupZone_body_entered(body):
	item_in_range[body] = body


func _on_PickupZone_body_exited(body):
	if item_in_range.has(body):
		item_in_range.erase(body)
