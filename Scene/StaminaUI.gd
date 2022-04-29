extends Control

var currentStaminaBar = 1 setget set_current_stamina_bar
var maxStaminaBar = 1 setget set_stamina_empty_bar

onready var staminaEmpty = $StaminaEmpty
onready var staminaFull = $StaminaFull

func set_stamina_empty_bar(value: int):
	maxStaminaBar = max(value, 1)
	if staminaEmpty != null:
		staminaEmpty.rect_size.x = maxStaminaBar
	
func set_current_stamina_bar(value: int):
	currentStaminaBar = clamp(value, 0, maxStaminaBar)
	if staminaFull != null:
		if currentStaminaBar < 5:
			staminaFull.rect_size.x = 0
		else:
			staminaFull.rect_size.x = currentStaminaBar
	
func _ready():
	self.set_stamina_empty_bar(PlayerStats.get_max_stamina())
	self.set_current_stamina_bar(PlayerStats.get_current_stamina())
	PlayerStats.connect("stamina_changed", self, "set_stamina_empty_bar")
	PlayerStats.connect("consume_stamina", self, "set_current_stamina_bar")
	PlayerStats.connect("recharge_saitama", self, "set_current_stamina_bar")

