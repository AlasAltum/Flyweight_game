extends Label

func _ready():
	var state_machine = get_node("/root/World/Player/StateMachine")
	state_machine.connect("state_changed", self, "_on_Player_state_changed")

func _on_Player_state_changed(state):
	set_text(state.get_name())
