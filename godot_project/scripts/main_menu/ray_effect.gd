extends ColorRect

onready var timer := $RayTimer as Timer
onready var ray_animation := $RayAnimation as AnimationPlayer

func _ready():
	timer.set_wait_time(5)
	timer.start()

func _on_RayTimer_timeout():
	if randf() < 0.8:
		ray_animation.play("RayAnimation")
