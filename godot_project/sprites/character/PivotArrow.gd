extends Node2D

var direction
var player : PlayerController

# Called when the node enters the scene tree for the first time.
func _ready():
	player = owner
	pass # Replace with function body.

func _physics_process(delta):
	direction = Vector2(get_global_mouse_position() - global_position).normalized()
	rotation = get_global_mouse_position().angle_to_point(global_position)
	
	var jump_direction = player. get_mouse_direction()
	var dir_amount = jump_direction.dot(player.direction)
	
	if player.get_node("StateMachine").current_state.get_name() =="Grab":
		if dir_amount < 0:
			rotation = get_global_mouse_position().angle_to_point(global_position)
		else:
			rotation = 3*PI/2
	else:
		if dir_amount > 0:
			rotation = get_global_mouse_position().angle_to_point(global_position)
		else:
			rotation = 3*PI/2
