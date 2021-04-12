class_name Run
extends OnGround

export(float) var RUN_ACCEL = 5
export(float) var MAX_RUN_SPEED = 150

func enter():
	player = owner
	player.get_node("AnimationPlayer").play("run")
	
func handle_input(event):
	return .handle_input(event)
	
func update(delta):
	motion = player.get_motion()
	direction = player.get_direction()
	motion.x += RUN_ACCEL * direction.x
	motion.y = 0
	motion.x = clamp(motion.x, -MAX_RUN_SPEED, MAX_RUN_SPEED)
	player.move(motion)
	
	if player.is_front_ray_colliding():
		player.change_direction()
	if not player.is_down_ray_colliding():
		emit_signal("finished", "fall")
		player.is_grounded = true
		player.get_node("GroundedTimer").start()
		return
	
	if player.is_jump_pressed:
		emit_signal("finished", "jump")
		player.is_jump_pressed = false
		return
