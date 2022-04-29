extends Control

onready var hotbar = $HotbarSlots
onready var slots = hotbar.get_children()

func _ready():
	for i in range(slots.size()):
		slots[i].slot_index = i
	initialize_inventory()
		
func initialize_inventory():
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
