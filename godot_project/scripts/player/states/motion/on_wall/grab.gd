class_name Grab
extends Motion

export(float) var SLIDE_ACCEL = 1
export(float) var MAX_SLIDE_SPEED = 100
export(int) var MAX_BUFF_VALUE = 200
export(int) var BUFF_INCREASE = 20
export(float) var BUFF_DECREASE = 1
export(int) var BUFF_INTERVAL_DECREASE_FX = 5

# Variable para saber si ya se alcanzo el valor maximo del buff
var max_buff = false
var decrease_amount = 0

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
		# Al saltar sobre la pared se añade el buff
		var jump_direction = player.get_mouse_direction()
		var dir_amount = jump_direction.dot(player.direction)
		if dir_amount < 0:
			player.change_direction()
			var tmp_value
			if (player.jump_buff >= MAX_BUFF_VALUE - player.jump_buff):
				tmp_value = MAX_BUFF_VALUE
				if not max_buff:
					max_buff = true
					player.max_buff_effect()
			else:
				max_buff = false
				tmp_value = player.jump_buff + BUFF_INCREASE
				# Generamos el efecto
				
				if player.jump_buff > 0:
					player.increase_buff_effect()
			player.jump_buff = tmp_value
			emit_signal("finished", "jump")
			owner.is_jump_pressed = false
			return
	
	motion = player.get_motion()
	if motion.y < MAX_SLIDE_SPEED:
		motion.y += SLIDE_ACCEL
		
	# REstamos el buff al estar deslizandose en la pared
	if (player.jump_buff > 0):
		if (motion.y > 50):
			# Se revisa si es que corresponde mostrar efecto cuando disminuye el buff
			decrease_amount += BUFF_DECREASE
			if (decrease_amount > (MAX_BUFF_VALUE / BUFF_INTERVAL_DECREASE_FX) 
				and player.jump_buff > BUFF_INCREASE):
				decrease_amount = 0
				player.decrease_buff_effect()
			player.jump_buff -= BUFF_DECREASE
	else:
		player.jump_buff = 0
	player.move(motion)
	
