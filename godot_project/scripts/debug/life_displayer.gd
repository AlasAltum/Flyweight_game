extends Label

func _ready():
	var health = get_node("/root/World/Player/Health")
	health.connect("lives_decreased",self,"_on_Player_health_changed")
	health.connect("lives_increased",self,"_on_Player_health_changed")
	self.set_text(str(health.health))

func _on_Player_health_changed(lifes):
	set_text(str(lifes))

