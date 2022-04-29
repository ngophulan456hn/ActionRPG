extends Control

var hearts = 1 setget set_hearts
var max_hearts = 1 setget set_max_hearts

onready var heartFull = $HeartFull
onready var heartEmpty = $HeartEmpty

func set_hearts(value: int):
	hearts = clamp(value, 0, max_hearts)
	if heartFull != null:
		heartFull.rect_size.x = hearts * 15
	
func set_max_hearts(value: int):
	max_hearts = max(value, 1)
	if heartEmpty != null:
		heartEmpty.rect_size.x = max_hearts * 15
	
func _ready():
	self.set_max_hearts(PlayerStats.get_max_health())
	self.set_hearts(PlayerStats.get_health())
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")

