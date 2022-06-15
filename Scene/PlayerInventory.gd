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
	1: ["Bomb", 1],
	2: ["Health Potion", 5]
}

var equips = {
#	0: ["Blue Shirt", 1],	#--> slot index: [item_name, item_quantity]
#	1: ["Brown Pant", 1],
#	2: ["Black Boot", 1],
}

var active_item_slot = 0
var active_item = null

func add_item(item_name, item_quantity):
	#check for item in hotbar first then check inventory
	for item in hotbar:
		if hotbar[item][0] == item_name:
			var stack_size = int(ItemData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - hotbar[item][1]
			if able_to_add >= item_quantity:
				hotbar[item][1] += item_quantity
				update_slot_visual(item, hotbar[item][0], hotbar[item][1], true)
				return
			else:
				hotbar[item][1] += able_to_add
				update_slot_visual(item, hotbar[item][0], hotbar[item][1], true)
				item_quantity -= able_to_add
				
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
			
func update_slot_visual(slot_index, item_name, new_quantity, is_hotbar: bool = false):
	var slot: SlotClass
	var world_scene = get_tree().get_current_scene().get_name()
	if is_hotbar:
		if world_scene == 'WorldScene':
			slot = get_tree().get_root().get_node("/root/WorldScene/CanvasLayer/Hotbar/HotbarSlots/HotbarSlot" + str(slot_index + 1))
		else:
			slot = get_tree().get_root().get_node("/root/DungeonScene/CanvasLayer/Hotbar/HotbarSlots/HotbarSlot" + str(slot_index + 1))
	else:
		if world_scene == 'WorldScene':
			slot = get_tree().get_root().get_node("/root/WorldScene/CanvasLayer/Inventory/GridContainer/Slot" + str(slot_index + 1))
		else:
			slot = get_tree().get_root().get_node("/root/DungeonScene/CanvasLayer/Inventory/GridContainer/Slot" + str(slot_index + 1))

	slot.slot_index = slot_index
	if is_hotbar:	
		slot.slot_type = SlotClass.SlotType.HOTBAR
	else:
		slot.slot_type = SlotClass.SlotType.INVENTORY
		
	if new_quantity == 0 && is_hotbar:
		remove_item(slot)
		slot.remove_item()
		if active_item_slot == slot.slot_index:
			active_item = null
	else:
		if slot.item != null:
			slot.item.set_item(item_name, new_quantity)
		else:
			slot.initialize_item(item_name, new_quantity)
		add_new_item_quantity(slot, new_quantity)

func check_item(item_name) -> bool:
	for item in inventory:
		if inventory[item][0] == item_name:
			return true
	for item in hotbar:
		if hotbar[item][0] == item_name:
			return true
	return false
	
func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
		_:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]
	
func remove_item(slot: SlotClass):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		_:
			equips.erase(slot.slot_index)

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
		_:
			equips[slot.slot_index][1] += quantity_to_add

func add_new_item_quantity(slot: SlotClass, new_quantity: int):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] = new_quantity
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] = new_quantity
		_:
			equips[slot.slot_index][1] = new_quantity
	
func active_item_scroll_up() -> void:
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOT
	emit_signal("active_item_updated")
	
func active_item_scroll_down() -> void:
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOT - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")
