extends Control

const SlotClass = preload("res://Scene/Slot.gd")

onready var label = $ActiveItemLabel
onready var hotbar = $HotbarSlots
onready var slots = hotbar.get_children()

func _ready():
	PlayerInventory.connect("active_item_updated", self, "update_active_item_label")
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
	initialize_hotbar()
	update_active_item_label()
			
func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		PlayerInventory.active_item = slots[PlayerInventory.active_item_slot].item
		label.text = slots[PlayerInventory.active_item_slot].item.item_name
	else:
		PlayerInventory.active_item = null
		label.text = ""
		
func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
	update_active_item_label()
			
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
			update_active_item_label()
				
func _input(event):
	if find_parent('CanvasLayer').holding_item:
		find_parent('CanvasLayer').holding_item.global_position = get_global_mouse_position()
		
	if event.is_action_pressed("ui_interact"):
		if PlayerInventory.active_item != null:
				if PlayerInventory.active_item.item_name == "Health Potion":
					heal_player()

func heal_player():
	PlayerStats.set_health(PlayerStats.get_health() + 1)
	PlayerInventory.update_slot_visual(PlayerInventory.active_item_slot, PlayerInventory.active_item.item_name, PlayerInventory.active_item.item_quantity - 1, true)
	initialize_hotbar()
	
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
				
func show_or_hide_item(is_show: bool):
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].item.visible = is_show
