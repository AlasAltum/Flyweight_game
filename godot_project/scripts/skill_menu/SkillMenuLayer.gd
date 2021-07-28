extends CanvasLayer

onready var menu_slots = $SkillMenu/GridContainer
onready var board_slots = $SkillMenu/Board/Slots
onready var skill_menu : SkillMenu = $SkillMenu
onready var player = LevelManager.player
signal continue_skill_menu


onready var jump_chip := $SkillMenu/GridContainer/Slot1/JumpChip as Node2D
onready var health_chip := $SkillMenu/GridContainer/Slot2/HealthChip as Node2D
onready var speed_chip := $SkillMenu/GridContainer/Slot3/SpeedChip as Node2D
onready var dash_chip := $SkillMenu/GridContainer/Slot4/DashChip as Node2D
onready var hook_chip := $SkillMenu/GridContainer/Slot5/HookChip as Node2D


onready var all_skills = [
				jump_chip,
				health_chip,
				speed_chip,
				dash_chip,
				hook_chip,
				]

onready var first_time_skills = LevelManager.first_time_skills
onready var available_skills = LevelManager.available_skills
onready var used = false

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
	if player.is_alive == false:
		return

	skill_menu.visible = true

	if used == false:
		for first_time_skill in first_time_skills:
			if first_time_skill:
				first_time_skill.appear_texture()
				available_skills.append(first_time_skill)
				first_time_skills.erase(first_time_skill)

		used = true

	for available_skill in available_skills:
		available_skill.get_parent().visible = true
		available_skill.visible = true

	get_tree().paused = true

# 3282 3347
func _on_skill_menu_continue():
	if player == null or skill_menu == null or player.is_alive == false:
		return

	skill_menu.visible = false
	get_tree().paused = false
