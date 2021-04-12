class_name Grab
extends Motion

export(float) var SLIDE_ACCEL = 1
export(float) var MAX_SLIDE_SPEED = 40

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
		emit_signal("finished", "jump")
		owner.is_jump_pressed = false
		return
	
	motion = player.get_motion()
	if motion.y < MAX_SLIDE_SPEED:
		motion.y += SLIDE_ACCEL
	player.move(motion)
	
