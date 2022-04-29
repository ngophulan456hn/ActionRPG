extends KinematicBody2D

const MAX_SPEED = 225
const ACCELERATION = 460

var velocity = Vector2.ZERO
var player = null
var being_pick_up = false

export var item_name: String = ''

func _ready():
	pass
	
func _physics_process(delta):
	if not being_pick_up:	
		velocity = velocity.move_toward(Vector2(0,MAX_SPEED), ACCELERATION * delta)
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 10:
			PlayerInventory.add_item(item_name, 1)
			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)
	
func pick_up_item(body):
	player = body
	being_pick_up = true
	
