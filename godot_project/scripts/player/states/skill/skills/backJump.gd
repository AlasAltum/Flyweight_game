class_name BackJump
extends Skill

export(float) var JUMP_FORCE = 300.0
var motion : Vector2
var jumpDirection : Vector2 = Vector2(- 1.0, -2.0).normalized()

func _ready():
	player = owner

func prepare_skill_update(delta):
	waiting_input = true

func start_skill():	
	motion = player.get_motion()
	if motion.x == 0:
		get_parent().finish_skill("fall")
		return
	motion.x = JUMP_FORCE * jumpDirection.x * player.direction.x
	motion.y = JUMP_FORCE * jumpDirection.y
	player.move(motion)
	player.get_node("SoundJump").update_pitch(player.jump_buff)
	player.get_node("SoundJump").play()
	player.get_node("AnimationPlayer").play("jump")
	
func update_skill(delta):
	if player.is_down_ray_colliding():
		get_parent().finish_skill("fall")
	else:
		get_parent().finish_skill("fall")
