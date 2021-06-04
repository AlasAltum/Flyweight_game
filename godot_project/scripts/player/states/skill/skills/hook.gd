class_name Hook
extends Skill

export(float) var THROW_SPEED = 300
export(float) var CLIMB_ACCEl = 20
export(float) var MAX_CLIMB_SPEED = 500
export(float) var MAX_GRAPPLING_DISTANCE = 300
export(float) var SKILL_WAIT_TIME = 3
export(float) var MAX_ACTIVE_TIME = 10
export(float) var TIME_TO_HOOK = 0.5

var raycast : RayCast2D
var grippling_point : Vector2
var point_is_stored = false
var can_draw_line = false
var hook_tip_distance = 0
var hook_tip_position = Vector2.ZERO
var hooked = false
var throwing_hook = false

func _ready():
	player = owner
	raycast = player.get_node("HookRayCast")
	enable = false
	waiting_input = false
	$ThrowingTimer.connect("timeout", self, "_on_Hook_fail_throw")

func activation_input(event):
	if event.is_action_pressed("skill") and not throwing_hook:
		hooked = false
		hook_tip_distance = 0
		hook_tip_position = Vector2.ZERO
		raycast.enabled = true
		var direction = player.get_mouse_direction()
		raycast.set_cast_to(MAX_GRAPPLING_DISTANCE * direction)
		point_is_stored = false
		throwing_hook = true
		

func prepare_skill_update(delta):
	if throwing_hook:
		if not point_is_stored:
			if raycast.is_colliding():
				grippling_point = raycast.get_collision_point()
				point_is_stored = true
				can_draw_line = true
			else:
				throwing_hook = false
		raycast.enabled = false
			
		if can_draw_line:
			if not hooked:
				var direction = (grippling_point - player.global_position).normalized()
				hook_tip_position = player.global_position + direction * hook_tip_distance
				var dist_to_point = square_distance(player.global_position, grippling_point)
				var dist_to_tip = square_distance(hook_tip_position, player.global_position)
				if dist_to_tip < dist_to_point:
					hook_tip_distance += THROW_SPEED * delta
				else:
					hooked = true
					waiting_input = true
					throwing_hook = false
					$ThrowingTimer.set_wait_time(SKILL_WAIT_TIME)
					$ThrowingTimer.start()
	if can_draw_line:
		$GripplingLine.clear_points()
		$GripplingLine.add_point(player.global_position)
		$GripplingLine.add_point(hook_tip_position)

func start_skill():
	player.set_motion(Vector2.ZERO)
	$ThrowingTimer.stop()
	$ThrowingTimer.set_wait_time(MAX_ACTIVE_TIME)
	$ThrowingTimer.start()
	if player.is_front_ray_colliding():
		player.change_direction()
	player.get_node("AnimationPlayer").play("fall")

func update_skill(delta):
	var active_time = MAX_ACTIVE_TIME - $ThrowingTimer.get_time_left()
	if Input.is_action_just_released("skill"):
		point_is_stored = true
		can_draw_line = false
		throwing_hook = false
		$GripplingLine.clear_points()
		get_parent().finish_skill("fall")
		return

	if active_time > TIME_TO_HOOK:
			
		if player.is_front_ray_colliding():
			point_is_stored = true
			can_draw_line = false
			throwing_hook = false
			$GripplingLine.clear_points()
			get_parent().finish_skill("grab")
			return
		if player.is_down_ray_colliding():
			point_is_stored = true
			can_draw_line = false
			throwing_hook = false
			$GripplingLine.clear_points()
			get_parent().finish_skill("run")
			return
		if player.is_up_ray_colliding():
			point_is_stored = true
			can_draw_line = false
			throwing_hook = false
			$GripplingLine.clear_points()
			get_parent().finish_skill("fall")
			return
		if player.is_back_ray_colliding():
			point_is_stored = true
			can_draw_line = false
			throwing_hook = false
			$GripplingLine.clear_points()
			get_parent().finish_skill("fall")
			return
	
	var direction = (grippling_point - player.global_position).normalized()
	var motion = player.get_motion()
	if motion.length_squared() < pow(MAX_CLIMB_SPEED, 2):
		motion += CLIMB_ACCEl * direction
	player.move(motion)
	
	
	$GripplingLine.clear_points()
	$GripplingLine.add_point(player.global_position)
	$GripplingLine.add_point(grippling_point)
	

func square_distance(vector1 : Vector2, vector2 : Vector2) -> float:
	return pow((vector1.x - vector2.x), 2) + pow((vector1.y - vector2.y), 2)
	
func _on_Hook_fail_throw():
	if not throwing_hook:
		$GripplingLine.clear_points()
		point_is_stored = true
		can_draw_line = false
		waiting_input = false

