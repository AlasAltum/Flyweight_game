extends CanvasLayer

onready var menu_slots = $SkillMenu/GridContainer
onready var board_slots = $SkillMenu/Board/Slots
onready var skill_menu : SkillMenu = $SkillMenu
onready var player = LevelManager.player
signal continue_skill_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	for slot in board_slots.get_children():
		slot.connect("activate_skill", player, "skill_on")
		slot.connect("deactivate_skill", player, "skill_off")
	skill_menu.get_node("Button").connect("continue_skill_menu", self, "_on_skill_menu_continue")
	skill_menu.visible = false
	$SkillMenu/Button.connect("continue_skill_menu", self, "_continue_skill_menu")

func _continue_skill_menu():
	emit_signal("continue_skill_menu")

func _input(event):
	if player == null or skill_menu == null:
		return
		
	if event.is_action_pressed("debug_skill"):
		activate_skill_menu()

func activate_skill_menu():
	skill_menu.set_visible(true)
#	skill_menu.pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true

func _on_skill_menu_continue():
	if player == null or skill_menu == null:
		return
		
	get_tree().paused = false
#	skill_menu.pause_mode = PAUSE_MODE_INHERIT
#	for slot in board_slots.get_children():
#		slot.connect("activate_skill", player, "skill_on")
#		slot.connect("deactivate_skill", player, "skill_off")
#	skill_menu.get_node("Button").disconnect("continue_skill_menu", self, "_on_skill_menu_continue")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
