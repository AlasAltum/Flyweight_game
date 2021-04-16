extends Label

var timer: Timer

func _ready():
	timer = get_node("/root/World/Player/StateMachine/Skill/CooldownTimer")
	
func _physics_process(delta):
	if timer != null:
		if timer.is_stopped():
			text = "READY!"
		else:
			text = str(stepify(timer.get_time_left(), 0.01)) + " s"
