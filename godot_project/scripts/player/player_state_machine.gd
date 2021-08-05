class_name PlayerStateMachine
extends StateMachine

func _ready():
	states_map = {
		"run" : $Run,
		"jump" : $Jump,
		"grab" : $Grab,
		"hurt" : $Hurt,
		"die" : $Die,
		"skill" : $Skill
	}
	var health = owner.get_node("Health")
	health.connect("lives_decreased_frozen",self,"_on_Player_change_to_hurt")

func _on_Player_change_to_hurt(amount):
	_change_state("hurt")

func _change_state(state_name):
	if not _active:
		return
	if state_name == "jump" and (current_state == $Run or current_state == $Grab):
		$Jump.initialize()
	if (owner.jump_buff != 0 and
		not (current_state == $Grab and state_name == 'jump' or 
			current_state == $Jump and state_name == 'grab')):
		# Buff de salto debe volver a 0
		owner.jump_buff = 0
	._change_state(state_name)
	
func _physics_process(delta):
	if not(current_state.get_name() in ["Hurt", "Skill"]):
		if Input.is_action_pressed("skill"): 
			if $Skill.current_skill.get_name() == "Null":
				return
			if ($Skill.can_use_skill) and $Skill.current_skill.waiting_input:
				$Skill.current_skill.enable = true
				_change_state("skill")
