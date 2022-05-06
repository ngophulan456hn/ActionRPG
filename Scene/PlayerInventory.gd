extends Node

signal active_item_updated

const NUM_INVENTORY_SLOT = 20
const NUM_HOTBAR_SLOT = 8

const SlotClass = preload("res://Scene/Slot.gd")
const ItemClass = preload("res://Scene/Item.gd")

var inventory = {
	0: ["Basic Sword", 1],	#--> slot index: [item_name, item_quantity]
	1: ["Basic Bow", 1],
	2: ["Bomb", 1],
	3: ["Health Potion", 1],
	4: ["Tea Leaf", 98]
}

var hotbar = {
	0: ["Basic Sword", 1],	#--> slot index: [item_name, item_quantity]
	1: ["Health Potion", 1],
}

var equips = {
	0: ["Basic Sword", 1],	#--> slot index: [item_name, item_quantity]
	1: ["Basic Bow", 1],
	2: ["Bomb", 1],
}

var active_item_slot = 0

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(ItemData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity -= able_to_add
	
	#item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOT):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return
			
func update_slot_visual(slot_index, item_name, new_quantity):
	var slot = null
	var world_scene = get_tree().get_current_scene().get_name()
	if world_scene == 'WorldScene':
		slot = get_tree().get_root().get_node("/root/WorldScene/CanvasLayer/Inventory/GridContainer/Slot" + str(slot_index + 1))
	else:
		slot = get_tree().get_root().get_node("/root/DungeonScene/CanvasLayer/Inventory/GridContainer/Slot" + str(slot_index + 1))
	print(slot)
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func check_item(item_name) -> bool:
	for i in range(NUM_INVENTORY_SLOT):
		if inventory.has(i):
			return true
	return false
	
func add_item_to_empty_slot(item: ItemClass, slot: SlotClass, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
	else:
		inventory[slot.slot_index] = [item.item_name, item.item_quantity]
	
func remove_item(slot: SlotClass, is_hotbar: bool = false):
	if is_hotbar:
		hotbar.erase(slot.slot_index)
	else:
		inventory.erase(slot.slot_index)

func add_item_quantity(slot: SlotClass, quantity_to_add: int, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.slot_index][1] += quantity_to_add
	else:
		inventory[slot.slot_index][1] += quantity_to_add
	
func active_item_scroll_up():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOT
	emit_signal("active_item_updated")
	
func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOT - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")
