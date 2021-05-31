extends Node2D

export(int) var damage = 1
export(float) var speed = 1
export(bool) var wait_on_point = false
export(float) var wait_time = 1.0
export(bool) var cycle = false
export(bool) var debug_points = false
export(int) var current_point = 0

var motion = Vector2.ZERO 
var direction : Vector2
var current_dir : Vector2
var controlPoints
var point_dir = 1
var can_move = true
var goal : Node2D 
var wall_collision : KinematicCollision2D

var player_in_wall = false

# Called when the node enters the scene tree for the first time.
func _ready():
	controlPoints = []
	for i in range(get_child_count()):
		if i > 1 :
			var child_node = get_child(i)
			if child_node is Node2D:
				controlPoints.append(child_node)
	
	# Si no hay puntos de control, se queda en idle
	if controlPoints == [] :
		can_move = false
		$AnimationPlayer.play("anim")
		return
	
	_cal_direction()
	$AnimationPlayer.play("anim")
	
	if not debug_points:
		for point in controlPoints:
			var tmp_sprite : Sprite = point.get_node("Sprite") 
			tmp_sprite.visible = false
			
	$Body/WaitPointTimer.set_wait_time(wait_time)
	$Body/WaitPointTimer.connect("timeout", self, "_on_WaitPointTimer_timeout")

func _update_point():
	current_point = (len(controlPoints) + current_point + point_dir) % len(controlPoints)
	_cal_direction()
	$Body.scale.x *= -1
	
	
func _cal_direction():
	if not cycle:
		if current_point == 0:
			point_dir = 1
		elif current_point == len(controlPoints)-1:
			point_dir = -1
	goal = controlPoints[(len(controlPoints) + current_point + point_dir) % len(controlPoints)]
	var current : Node2D = controlPoints[current_point]
	direction = (goal.position - $Body.position).normalized()
			
	
func _physics_process(delta):
	for body in $Body/Area2D.get_overlapping_bodies():
		if body is PlayerController:
			body.apply_damage(damage)
	
	if wall_collision != null:
		if wall_collision.collider is PlayerController:
			$Body/WaitPointTimer.stop()
			player_in_wall = true
	elif player_in_wall:
		$Body/WaitPointTimer.start()
		player_in_wall = false
		
		
	if can_move:
		current_dir = goal.position - $Body.position
		var product = direction.dot(current_dir)
		if product < 0 :
			if wait_on_point:
				can_move = false
				$Body/WaitPointTimer.start()
				return
			_update_point()
		motion = direction * speed
	else:
		motion = Vector2.ZERO
	wall_collision = $Body.move_and_collide(motion)
	
func _on_WaitPointTimer_timeout():
	can_move = true
	_update_point()
