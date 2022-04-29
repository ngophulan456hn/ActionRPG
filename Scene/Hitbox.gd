extends Area2D

export var damage = 1 setget set_damage, get_damage

func set_damage(value: int):
	if value <= 0 :
		print('Cannot set damage less than 0')
	else:
		damage = value
		
func get_damage() -> int:
	return damage
