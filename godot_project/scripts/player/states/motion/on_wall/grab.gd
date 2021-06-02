class_name Grab
extends Motion

export(float) var SLIDE_ACCEL = 1
export(float) var MAX_SLIDE_SPEED = 40
export(float) var MAX_BUFF_VALUE = 200
export(float) var BUFF_INCREASE = 20
export(float) var BUFF_DECREASE = 1

func enter():
	player = owner
	player.get_node("AnimationPlayer").play("grab")
	player.set_motion(Vector2.ZERO)
	
func handle_input(event):
	return .handle_input(event)

func update(delta):
	if not player.is_front_ray_colliding():
		player.change_direction()
		emit_signal("finished", "fall")
		return
	if player.is_down_ray_colliding():
		emit_signal("finished", "run")
		return
	if owner.is_jump_pressed:
		player.change_direction()
		# Al saltar sobre la pared se añade el buff
		var tmp_value
		if (player.jump_buff >= MAX_BUFF_VALUE - player.jump_buff):
			tmp_value = MAX_BUFF_VALUE
		else:
			tmp_value = player.jump_buff + BUFF_INCREASE
		player.jump_buff = tmp_value
		emit_signal("finished", "jump")
		owner.is_jump_pressed = false
		return
	
	motion = player.get_motion()
	if motion.y < MAX_SLIDE_SPEED:
		motion.y += SLIDE_ACCEL
		
	# REstamos el buff al estar deslizandose en la pared
	if (player.jump_buff > 0):
		player.jump_buff -= BUFF_DECREASE
	else:
		player.jump_buff = 0
	player.move(motion)
	
