class_name Jump
extends Motion

export(float) var GRAVITY = 10
export(float) var MAX_FALLS_SPEED = 200
export(float) var JUMP_SPEED_X = 320
export(float) var JUMP_SPEED_Y = 320
export(float, 0, 1) var MOTION_CONSERVATION_X = 0.5
export(float, 0, 1) var MOTION_CONSERVATION_Y = 0.5
export(float, 0, 1) var DECREASE_IN_RELEASE = 0.5

func initialize():
	player = owner
	_start_jump()

func enter():
	player = owner
	
func update(delta):
	motion = player.get_motion()
	
	if motion.y < 0:
		player.get_node("AnimationPlayer").play("jump")
		if Input.is_action_just_released("basic_jump"):
			motion.y = motion.y * DECREASE_IN_RELEASE
	else:
		player.get_node("AnimationPlayer").play("fall")
	
	if player.is_down_ray_colliding():
		emit_signal("finished", "run")
		return
		
	if player.is_front_ray_colliding():
		emit_signal("finished", "grab")
		return
	
	if motion.y < MAX_FALLS_SPEED:
		motion.y += GRAVITY	
	player.move(motion)
	
	if player.is_jump_pressed and player.is_grounded:
		_start_jump()
		player.is_jump_pressed = false
		player.is_grounded = false
		return

func _start_jump():
	player.get_node("AnimationPlayer").play("jump")
	var jump_direction = player.get_mouse_direction()
	motion = player.get_motion()
	var jump_x = JUMP_SPEED_X + player.jump_buff
	var jump_y = JUMP_SPEED_Y + player.jump_buff
	# Se realiza el salto solo si es un salto en la misma direccion del player
	var dir_amount = jump_direction.dot(player.direction)
	if dir_amount > 0:
		motion.x = motion.x * MOTION_CONSERVATION_X + jump_direction.x * jump_x
		motion.y = motion.y * MOTION_CONSERVATION_Y + jump_direction.y * jump_y
	else:
		motion.x = 0
		motion.y = motion.y * MOTION_CONSERVATION_Y + jump_direction.y * jump_y
	player.move(motion)
