class_name Player
extends KinematicBody2D

# TODO: Ver si borrar una vez implementada la estación

#export var GRAVITY = 10
#const MAX_FALLS_SPEED = 200
#const RUN_ACCEL = 50
#const MAX_RUN_SPEED = 200
#const JUMP_SPEED = 380
#const SLIDE_ACCEL = 1
#const MAX_SLIDE_SPEED = 20
#
#var down_ray_cast : RayCast2D
#var front_ray_cast : RayCast2D
#var trajectory_line : Line2D
#var animation : AnimationPlayer
#
#var direction = Vector2()
#var motion = Vector2()
#var jump_direction = Vector2()
#var is_colliding_floor : bool = false
#var is_colliding_front : bool = false
#var draw_trajectory : bool = false
#var trajectory_pos = Vector2()
#var trajectory_vel = Vector2()
#var trajectory_jump = Vector2()
#
#func _ready():
#	direction.x = 1
#	animation = $AnimationPlayer
#	animation.play("run")
#	front_ray_cast = $FrontRayCast
#	down_ray_cast = $DownRayCast
#	trajectory_line = get_node("/root/World/TrajectoryLine2D")
#
#func _physics_process(delta):
#	update_trajectory(delta)
#	motion.y += GRAVITY
#	if down_ray_cast.is_colliding():
#		animation.play("run")
#		is_colliding_floor = true
#		motion.x += RUN_ACCEL * direction.x
#		motion.y = 0
#		motion.x = clamp(motion.x, -MAX_RUN_SPEED, MAX_RUN_SPEED)
#		if front_ray_cast.is_colliding():
#			is_colliding_front = true
#			change_direction()
#		else:
#			is_colliding_front = false
#		if Input.is_action_just_pressed("basic_jump"):
#			jump_direction = Vector2(get_global_mouse_position() - position).normalized()
#			motion += jump_direction * JUMP_SPEED
#	else:
#		is_colliding_floor = false
#		if front_ray_cast.is_colliding():
#			animation.play("grab")
#			if (not is_colliding_front): # Personaje se agarra a la pared cuando esta en el aire
#				motion.x = 0
#				motion.y = 0
#			else:
#				motion.y += SLIDE_ACCEL - GRAVITY
#			is_colliding_front = true
#			if Input.is_action_just_pressed("basic_jump"):
#				change_direction()
#				motion.y = 0
#				jump_direction = Vector2(get_global_mouse_position() - position).normalized()
#				motion += jump_direction * JUMP_SPEED
#		else:
#			is_colliding_front = false
#			if motion.y < 0:
#				animation.play("jump")
#			else:
#				animation.play("fall")
#	motion = move_and_slide(motion, Vector2.UP)
#
#
## Funcion que cambia la direccion de distintas variables del player
#func change_direction():
#	var cast_to = front_ray_cast.get_cast_to() # Se obtiene la direcccion del raycast frontal
#	front_ray_cast.set_cast_to(Vector2(cast_to.x * -1, cast_to.y)) # Se cambia la direccion del raycast frontal
#	direction.x *= -1 # Se cambia el sentido del vector que indica la direccion de movimiento
#	$Sprite.scale.x *= -1 # Se cambia la direcciond el sprite
#
## Funcion para dibujar una trajectoria aproximada del salto
#func update_trajectory(delta):
#	if Input.is_action_just_pressed("show_trajectory"):
#		draw_trajectory = not draw_trajectory
#
#	trajectory_line.clear_points()
#
#	if draw_trajectory:
#		if (is_colliding_floor or is_colliding_front) and motion.y >= 0:
#			trajectory_pos = global_position
#			trajectory_vel = motion
#			trajectory_jump = Vector2(get_global_mouse_position() - trajectory_pos).normalized()* JUMP_SPEED
#
#		var temp_pos = trajectory_pos
#		var temp_vel = trajectory_vel
#		temp_vel += trajectory_jump 
#		for i in 300:
#			trajectory_line.add_point(temp_pos)
#			temp_vel.y += GRAVITY
#			temp_pos += temp_vel * delta

#func enter_station():
#	print('Enter station')
#
#func exit_station():
#	pass
