extends Node2D

onready var textureRect = $TextureRect
onready var label = $Label

var item_name
var item_quantity

func _ready():
	var rand_val = randi() % 5
	if rand_val == 0:
		item_name = "Basic Sword"
	elif rand_val == 1:
		item_name = "Basic Bow"
	elif rand_val == 2:
		item_name = "Health Potion"
	elif rand_val == 3:
		item_name = "Bomb"
	else:
		item_name = "Tea Leaf"
	
	load_texture(item_name)
	var stack_size = int(ItemData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		label.visible = false
	else:
		label.text = String(item_quantity)

func load_texture(item_name):
	match item_name:
		"Basic Sword":
			textureRect.texture = load("res://Items/Weapons/Sword2/Sprite.png")
		"Basic Bow":
			textureRect.texture = load("res://Items/Weapons/Bow2/Sprite.png")
		"Health Potion":
			textureRect.texture = load("res://Items/Potion/LifePot.png")
		"Tea Leaf":
			textureRect.texture = load("res://Items/Food/TeaLeaf.png")
		"Bomb":
			textureRect.texture = load("res://Items/Weapons/Bomb/bomb.png")
		_:
			textureRect.texture = load("res://Items/Potion/Hear.png")

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	load_texture(item_name)
	
	var stack_size = int(ItemData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		label.visible = false
	else:
		label.visible = true
		label.text = String(item_quantity)
		
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	label.text = String(item_quantity)
