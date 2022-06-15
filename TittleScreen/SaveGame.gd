extends Node

const SAVEFILE = "res://SaveGame.save"

var game_data = {
	"max_health": 4,
	"health": 4,
	"world_scene": "WorldScene.tscn",
	"position": Vector2(0,0),
	"spawn_position": Vector2(0,0),
	"pig": false,
	"inventory": PlayerInventory.inventory,
	"hotbar": PlayerInventory.hotbar,
	"equips": PlayerInventory.equips
}

func _ready():
	#save_data(game_data)
	pass
		
func save_data(game_data):
	var file = File.new()
	print('save_data::', game_data)
	file.open(SAVEFILE, File.WRITE)
	file.store_var(game_data)
	file.close()
	
func load_game():
	var file = File.new()
	file.open(SAVEFILE, File.READ)
	game_data = file.get_var()
	file.close()
	print('load_game::', game_data)
	PlayerStats.set_health(game_data.health)
	PlayerStats.set_max_health(game_data.max_health)
	PlayerStats.set_last_location(game_data.position)
	PlayerInventory.inventory = game_data.inventory
	PlayerInventory.hotbar = game_data.hotbar
	PlayerInventory.equips = game_data.equips
	get_tree().change_scene("res://Scene/" + game_data.world_scene)
	
