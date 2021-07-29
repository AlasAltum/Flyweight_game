class_name Run
extends OnGround

export(float) var RUN_ACCEL = 20
export(float) var MAX_RUN_SPEED = 300

func enter():
	player = owner
	motion = player.get_motion()
	motion.y = 0
	player.move(motion)
	
	player.get_node("AnimationPlayer").play("run")
	
func handle_input(event):
	return .handle_input(event)
	
func update(delta):
	motion = player.get_motion()
	direction = player.get_direction()
	# Corregir el deslizamiento al caer hacia atras
	
	motion.x += RUN_ACCEL * direction.x
	motion.x = clamp(motion.x, -MAX_RUN_SPEED, MAX_RUN_SPEED)
	player.move(motion)
	
	if player.is_front_ray_colliding():
		player.change_direction()
	if not player.is_down_ray_colliding():
		emit_signal("finished", "fall")
		# print("xD")
		player.is_grounded = true
		player.get_node("GroundedTimer").start()
		return
	else:
		if (player.direction.x * player.motion.x < 0) :
			motion.x = 0
			player.move(motion)
	
	if player.is_jump_pressed:
		emit_signal("finished", "jump")
		player.is_jump_pressed = false
		return
