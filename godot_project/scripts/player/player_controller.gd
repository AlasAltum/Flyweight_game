extends KinematicBody2D
class_name PlayerController

var motion : Vector2 = Vector2.ZERO
var fixed_position: Vector2 = Vector2.ZERO
var previous_motion : Vector2 = Vector2.ZERO
var previous_direction : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.RIGHT
var is_jump_pressed = false
var is_grounded = false
onready var health_object := $Health as Health
onready var player_state_machine := $StateMachine as PlayerStateMachine 


func _ready():
	LevelManager.player = self
	$JumpPressedTimer.connect("timeout", self, "_on_Player_jump_not_pressed")
	$GroundedTimer.connect("timeout", self, "_on_Player_is_not_grounded")

func _input(event):
	if event.is_action_pressed("simulate_damage"):
		$Health.take_damage(1)
	if event.is_action_pressed("simulate_heal"):
		$Health.heal(1)
	if event.is_action_pressed("basic_jump") and not is_jump_pressed:
		is_jump_pressed = true
		$JumpPressedTimer.start()

func apply_damage(amount):
	$Health.take_damage(amount)
	if $Health.health == 0:
		get_tree().reload_current_scene()

func get_motion() -> Vector2 :
	return motion

func set_motion(new_motion:Vector2) -> void:
	motion = new_motion

func move(new_motion : Vector2) -> void:
	motion = move_and_slide(new_motion, Vector2.UP)

func is_front_ray_colliding() -> bool:
	return $FrontRayCast.is_colliding()
	
func is_down_ray_colliding() -> bool:
	var is_colliding = $DownRayCast.is_colliding() or $DownRayCast2.is_colliding() or $DownRayCast3.is_colliding()
	return is_colliding

func is_up_ray_colliding() -> bool:
	return $UpRayCast.is_colliding()

func is_back_ray_colliding() -> bool:
	return $BackRayCast.is_colliding()
	
func get_front_ray_cast_to() -> Vector2:
	return $FrontRayCast.get_cast_to()
	
func set_front_ray_cast_to(direction : Vector2):
	$FrontRayCast.set_cast_to(direction)
	
func change_direction():
	var cast_to = get_front_ray_cast_to()
	set_front_ray_cast_to(Vector2(cast_to.x * -1, cast_to.y))
	cast_to = $BackRayCast.get_cast_to()
	$BackRayCast.set_cast_to(Vector2(cast_to.x * -1, cast_to.y))
	direction = get_direction()
	set_direction(Vector2(direction.x * -1, direction.y))
	change_sprite_direction()

func get_direction() -> Vector2:
	return direction
	
func set_direction(new_direction : Vector2) -> void:
	direction = new_direction
	
func change_sprite_direction() -> void:
	$Sprite.flip_h = not $Sprite.flip_h
	
func get_mouse_direction() -> Vector2:
	return Vector2(get_global_mouse_position() - position).normalized()
	
func _on_Player_jump_not_pressed():
	is_jump_pressed = false

func _on_Player_is_not_grounded():
	is_grounded = false
	
func skill_on(skill_name, skill_value):
	print("activate: " + skill_name + ", " + str(skill_value))
	match skill_name:
		"Hook":
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Hook
		"Dash":
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Dash
		"Health":
			$Health.increase_max_health(skill_value)
		"Speed":
			$StateMachine/Run.MAX_RUN_SPEED += skill_value
		"Jump":
			$StateMachine/Jump.JUMP_SPEED_X += skill_value
			$StateMachine/Jump.JUMP_SPEED_Y += skill_value

func skill_off(skill_name, skill_value):
	print("deactivate: " + skill_name + ", " + str(skill_value))
	match skill_name:
		"Hook":
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Null
		"Dash":
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Null
		"Health":
			$Health.decrease_max_health(skill_value)
		"Speed":
			$StateMachine/Run.MAX_RUN_SPEED -= skill_value
		"Jump":
			$StateMachine/Jump.JUMP_SPEED_X -= skill_value
			$StateMachine/Jump.JUMP_SPEED_Y -= skill_value
	

func enter_station():
	print('Enter station')

func exit_station():
	pass
