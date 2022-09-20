extends YSort

onready var chest = $Slimes/Chest
onready var slimes = $Slimes

func _ready():
	chest.visible = false
	
func _process(delta):
	if slimes.get_child_count() == 0 and is_instance_valid(chest):
		chest.visible = true

