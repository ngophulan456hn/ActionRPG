extends Area2D

export var item_name: String = ''

func _on_body_entered(body):
	if body.name == "Player":
		PlayerInventory.add_item(item_name, 1)
		queue_free()
