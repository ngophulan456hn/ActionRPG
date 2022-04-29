extends Node

var max_health = 1 setget set_max_health, get_max_health
var max_stamina = 60 setget set_max_stamina, get_max_stamina
var last_location = Vector2.ZERO setget set_last_location, get_last_location
var spawn_position = Vector2.ZERO setget set_spawn_position, get_spawn_position

onready var health = max_health setget set_health, get_health
onready var current_stamina = max_stamina setget set_current_stamina, get_current_stamina

signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal stamina_changed(value)
signal consume_stamina(value)
signal recharge_saitama(value)

func set_health(value: int):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
	
func get_health() -> int:
	return health
	
func set_max_health(value: int):
	max_health = max(value, 1)
	emit_signal("max_health_changed", max_health)
	
func get_max_health() -> int:
	return max_health
	
func set_current_stamina(value: float):
	current_stamina = clamp(value, 0, max_stamina)
	
func get_current_stamina() -> int:
	return current_stamina
	
func set_max_stamina(value: int):
	max_stamina = max(value, 1)
	emit_signal("stamina_change", max_stamina)
	
func get_max_stamina() -> int:
	return max_stamina
	
func consume_stamina():
	set_current_stamina(current_stamina - 20)
	emit_signal("consume_stamina", current_stamina)
	
func recharge_saitama(value: float):
	set_current_stamina(value)
	emit_signal("recharge_saitama", current_stamina)
	
func set_last_location(position: Vector2):
	last_location = position
	
func get_last_location() -> Vector2:
	return last_location
	
func set_spawn_position(location: Vector2):
	spawn_position = location
	
func get_spawn_position():
	return spawn_position
