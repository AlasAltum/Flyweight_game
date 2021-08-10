class_name Dash
extends Skill

export(float) var DASH_SPEED = 400
var motion : Vector2
var direction : Vector2
var time_threshold
var was_on_wall = false
var last_motion_x

func _ready():
	player = owner
	$ActivateTimer.connect("timeout", self, "_on_dash_finish_skill")
	time_threshold = $ActivateTimer.get_wait_time() * 0.5

func prepare_skill_update(delta):
	waiting_input = true

func start_skill():
	last_motion_x = player.get_motion().x
	player.get_node("AnimationPlayer").play("dash")
	$DashSound.play()
	$ActivateTimer.start()
	if player.is_front_ray_colliding():
		player.change_direction()
	direction = player.get_direction()
	
func update_skill(delta):
	motion = player.get_motion()
	motion.y = 0
	motion.x = DASH_SPEED * direction.x
	player.move(motion)
	
	if player.is_front_ray_colliding() and $ActivateTimer.get_time_left() < time_threshold:
		get_parent().finish_skill("grab")
		$ActivateTimer.stop()

func _on_dash_finish_skill():
	player.set_motion(Vector2(last_motion_x * 0.7, 0))
	if player.is_down_ray_colliding():
		get_parent().finish_skill("run")
	elif player.is_front_ray_colliding():
		get_parent().finish_skill("grab")
	else:
		get_parent().finish_skill("fall")
