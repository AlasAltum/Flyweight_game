extends CanvasLayer

onready var player := LevelManager.player as PlayerController
onready var state_label := $PushDownDebug/State as Label
onready var life_label := $LifeDebug/Amount as Label
onready var cd_time_label := $CooldownDebug/Time as Label
var timer: Timer


func _ready():
	pass
	# Connect state machine
#	player.player_state_machine.connect("state_changed", self, "_on_Player_state_changed")
#	player.connect("health_changed", self, "_on_Player_health_changed")
#	# Connect to health Node
#	var health = player.health_object as Health
#	health.connect("lives_increased",self,"_on_Player_health_changed")
#	health.connect("lives_decreased",self,"_on_Player_health_changed")
#	timer = player.get_cd_timer
#	life_label.set_text(str(health.health))
#	timer = get_node("/root/World/Player/StateMachine/Skill/CooldownTimer")

func _on_Player_state_changed(state):
	state_label.set_text(state.get_name())

func _on_Player_health_changed(lifes):
	life_label.set_text(str(lifes))

func _physics_process(_delta):
	if timer != null:
		if timer.is_stopped():
			cd_time_label.text = "READY!"
		else:
			cd_time_label.text = str(stepify(timer.get_time_left(), 0.01)) + " s"
