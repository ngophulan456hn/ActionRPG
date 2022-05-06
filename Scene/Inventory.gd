extends Control

onready var soundEffect = $SoundEffects

const SlotClass = preload("res://Scene/Slot.gd")

onready var inventory_slots = $GridContainer
onready var slots = inventory_slots.get_children()
onready var equip_slots= $EquipSlots.get_children()

func _ready():
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.INVENTORY
		
	for i in range(equip_slots.size()):
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
		equip_slots[i].slot_index = i
	equip_slots[0].slot_type = SlotClass.SlotType.SHIRT
	equip_slots[1].slot_type = SlotClass.SlotType.PANT
	equip_slots[2].slot_type = SlotClass.SlotType.BOOT
	initialize_inventory()
	initialize_equips()
		
func initialize_inventory():
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
	
func initialize_equips():
	for i in range(equip_slots.size()):
		if PlayerInventory.equips.has(i):
			equip_slots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])
	
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			# Currently holding an Item
			if find_parent('CanvasLayer').holding_item != null:
				# Empty slot
				if !slot.item: # Place holding item to slot
					left_click_empty_slot(slot)
				# Slot already contains an item
				else:
					# Different item, so swap
					if find_parent('CanvasLayer').holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					# Same item, so try to merge
					else:
						left_click_same_item(slot)
			# Not holding an item
			elif slot.item:
				left_click_not_holding(slot)
				
func _input(event):
	if find_parent('CanvasLayer').holding_item:
		find_parent('CanvasLayer').holding_item.global_position = get_global_mouse_position()
		
func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(find_parent('CanvasLayer').holding_item, slot)
	slot.putIntoSlot(find_parent('CanvasLayer').holding_item)
	find_parent('CanvasLayer').holding_item = null
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent('CanvasLayer').holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent('CanvasLayer').holding_item)
	find_parent('CanvasLayer').holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(ItemData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent('CanvasLayer').holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, find_parent('CanvasLayer').holding_item.item_quantity)
		slot.item.add_item_quantity(find_parent('CanvasLayer').holding_item.item_quantity)
		find_parent('CanvasLayer').holding_item.queue_free()
		find_parent('CanvasLayer').holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		find_parent('CanvasLayer').holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	find_parent('CanvasLayer').holding_item = slot.item
	slot.pickFromSlot()
	find_parent('CanvasLayer').holding_item.global_position = get_global_mouse_position()
				

