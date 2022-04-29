extends Area2D

func _on_MaxHeartDrop_body_entered(body):
	if body.name == "Player":
		PlayerStats.set_max_health(PlayerStats.get_max_health() +1)
		queue_free()
