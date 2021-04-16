class_name GameManager
extends Node

onready var player : PlayerController = find_parent("World").get_node("Player")
onready var skill_menu : SkillMenu = find_parent("World").get_node("SkillMenuLayer/SkillMenu")
onready var board_slots = find_parent("World").get_node("SkillMenuLayer/SkillMenu/Board/Slots")

func _ready():
	player = find_parent("World").get_node("Player")
	skill_menu = find_parent("World").get_node("SkillMenuLayer/SkillMenu")
	
	if skill_menu != null:
		skill_menu.set_visible(false)
	
func _input(event):
	if player == null or skill_menu == null:
		return
		
	if event.is_action_pressed("debug_skill"):  
		activate_skill_menu()

func activate_skill_menu():
	for slot in board_slots.get_children():
		slot.connect("activate_skill", player, "skill_on")
		slot.connect("deactivate_skill", player, "skill_off")
	skill_menu.get_node("Button").connect("continue_skill_menu", self, "_on_skill_menu_continue")
	skill_menu.set_visible(true)
	skill_menu.pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true

func _on_skill_menu_continue():
	if player == null or skill_menu == null:
		return
		
	get_tree().paused = false
	skill_menu.pause_mode = PAUSE_MODE_INHERIT
	for slot in board_slots.get_children():
		slot.connect("activate_skill", player, "skill_on")
		slot.connect("deactivate_skill", player, "skill_off")
	skill_menu.get_node("Button").disconnect("continue_skill_menu", self, "_on_skill_menu_continue")
