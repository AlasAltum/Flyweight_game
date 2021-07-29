class_name SkillManager
extends State

export(NodePath) var START_SKILL
onready var current_skill : Skill = $Null
var can_use_skill = true

func _ready():
	current_skill = get_node(START_SKILL)
	$CooldownTimer.connect("timeout", self, "_on_Manager_cooldown_is_over")

func enter():
	current_skill.start_skill()
	
func update(delta):
	current_skill.update_skill(delta)

func _input(event):
	if current_skill == null :
		return
	
	if not current_skill.enable:
		current_skill.activation_input(event)

func _physics_process(delta):
	if current_skill == null :
		return
		
	if not current_skill.enable:
		current_skill.prepare_skill_update(delta)

func finish_skill(state):
	can_use_skill = false
	current_skill.enable = false
	current_skill.waiting_input = false
	$CooldownTimer.set_wait_time(current_skill.cooldown)
	$CooldownTimer.start()
	emit_signal("finished", state)
	
func _on_Manager_cooldown_is_over():
	can_use_skill = true
