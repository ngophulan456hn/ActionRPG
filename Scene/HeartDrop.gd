extends Area2D

func _on_HeartDrop_body_entered(body):
	if body.name == "Player":
		if PlayerStats.get_health() == PlayerStats.get_max_health():
			pass
		else:
			PlayerStats.set_health(PlayerStats.get_health() +1)
		queue_free()

