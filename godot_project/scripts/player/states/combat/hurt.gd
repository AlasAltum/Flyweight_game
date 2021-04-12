class_name Hurt
extends Motion

func _ready():
	$FrozenTimer.connect("timeout", self, "_on_Hurt_change_to_fall")

func enter():
	$FrozenTimer.start()
	owner.set_motion(Vector2.ZERO)
	owner.get_node("AnimationPlayer").play("fall")
	if owner.is_front_ray_colliding():
		owner.change_direction()
	
func _on_Hurt_change_to_fall():
	emit_signal("finished", "fall")
