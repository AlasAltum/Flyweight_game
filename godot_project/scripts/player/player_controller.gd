extends KinematicBody2D
class_name PlayerController

var motion : Vector2 = Vector2.ZERO
var fixed_position: Vector2 = Vector2.ZERO
var previous_motion : Vector2 = Vector2.ZERO
var previous_direction : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.RIGHT
var is_jump_pressed = false
var is_grounded = false
var jump_buff : float = 0.0 setget set_jump_buff
var is_alive = true
onready var health_object := $Health as Health
onready var player_state_machine := $StateMachine as PlayerStateMachine 
onready var player_camera := $Camera2D as Camera2D

# Valores para el efecto al cambiar los valores del buff de salto
const buffFxPosition = Vector2(0, -20)
const increaseBuffFx = preload("res://prefabs/vfx/increaseBuffEffect.tscn")
const decreaseBuffFx = preload("res://prefabs/vfx/decreaseBuffEffect.tscn")
const maxBuffFx = preload("res://prefabs/vfx/maxBuffEffect.tscn")
const zeroBuffFx = preload("res://prefabs/vfx/zeroBuffEffect.tscn")

export(bool) var left_start_direction = true

signal buff_changed(buff_amount)
signal switch_skill()

var skill_index = 0
var skill_switch = false

func _ready():
	LevelManager.player = self
	$JumpPressedTimer.connect("timeout", self, "_on_Player_jump_not_pressed")
	$GroundedTimer.connect("timeout", self, "_on_Player_is_not_grounded")
	$StateMachine/Skill.current_skill = $StateMachine/Skill/Hook

	if left_start_direction:
		change_direction()


func _input(event):
	if event.is_action_pressed("basic_jump") and not is_jump_pressed:
		is_jump_pressed = true
		$JumpPressedTimer.start()
	if event.is_action_pressed("switch_skill"):
		skill_index = (skill_index + 1) % 2
		if skill_index == 0:
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Hook
		if skill_index == 1:
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Dash
		emit_signal("switch_skill")

func player_death():
	is_alive = false
	self.visible = false
	$DeathAnimation/player_death_explosion.position = self.position
	$DeathAnimation.play("deathAnimation")


func _on_DeathAnimation_animation_finished(anim_name):
	LevelManager.game_over()

func apply_damage(amount):
	$Health.take_damage(amount)
	if $Health.health == 0:
		player_death()
		
func apply_damage_from_mist(amount):
	$Health.take_damage_from_mist(amount)
	if $Health.health == 0:
		player_death()

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

	match skill_name:
		"Hook":
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Hook
		"Dash":
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Dash
		"BackJump":
			$StateMachine/Skill.current_skill = $StateMachine/Skill/BackJump
			$StateMachine/Skill/BackJump.JUMP_FORCE += skill_value
		"Health":
			$Health.increase_max_health(skill_value)
		"Speed":
			$StateMachine/Run.MAX_RUN_SPEED += skill_value
		"Jump":
			$StateMachine/Jump.JUMP_SPEED_X += skill_value
			$StateMachine/Jump.JUMP_SPEED_Y += skill_value

func skill_off(skill_name, skill_value):
	match skill_name:
		"Hook":
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Null
		"Dash":
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Null
		"BackJump":
			$StateMachine/Skill.current_skill = $StateMachine/Skill/Null
			$StateMachine/Skill/BackJump.JUMP_FORCE -= skill_value
		"Health":
			$Health.decrease_max_health(skill_value)
		"Speed":
			$StateMachine/Run.MAX_RUN_SPEED -= skill_value
		"Jump":
			$StateMachine/Jump.JUMP_SPEED_X -= skill_value
			$StateMachine/Jump.JUMP_SPEED_Y -= skill_value

func set_jump_buff(value : float):
	if (value == 0 and jump_buff != 0):
		zero_buff_effect()
	jump_buff = value
	emit_signal("buff_changed", value)

func increase_buff_effect():
	# Instancia efecto de aumento del buff de salto
	var effectInstance = increaseBuffFx.instance()
	get_parent().add_child(effectInstance)
	effectInstance.position = self.position + buffFxPosition
	
func decrease_buff_effect():
	# Instancia efecto de decremento del buff de salto
	var effectInstance = decreaseBuffFx.instance()
	get_parent().add_child(effectInstance)
	effectInstance.position = self.position + buffFxPosition
	
func max_buff_effect():
	# Instancia efecto de valor maximo alcanzado del buff de salto
	var effectInstance = maxBuffFx.instance()
	get_parent().add_child(effectInstance)
	effectInstance.position = self.position + buffFxPosition
	
func zero_buff_effect():
	# Instancia efecto del buff de salto nulo
	var effectInstance = zeroBuffFx.instance()
	get_parent().add_child(effectInstance)
	effectInstance.position = self.position + buffFxPosition

