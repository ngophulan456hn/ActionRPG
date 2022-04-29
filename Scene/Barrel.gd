extends StaticBody2D

const ObjectEffect = preload("res://Scene/ObjectEffect.tscn")
const HeartDrop = preload("res://Scene/HeartDrop.tscn")

func create_effect():
	var objectEffect = ObjectEffect.instance()
	get_parent().add_child(objectEffect)
	objectEffect.global_position = global_position

func create_heart_drop():
	var heartDrop = HeartDrop.instance()
	get_parent().add_child(heartDrop)
	heartDrop.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_effect()
	var percent = randf()
	if (percent > 0.7):
		create_heart_drop()
	queue_free()
	
func _on_Hurtbox_body_entered(body):
	create_effect()
	queue_free()
