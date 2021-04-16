class_name SkillMenu
extends Node2D

onready var menu_slots = $GridContainer
onready var board_slots = $Board/Slots
var holding_chip = null

func _ready():
	for menu_slot in menu_slots.get_children():
		menu_slot.connect("gui_input", self, "slot_gui_input", [menu_slot])
	for board_slot in board_slots.get_children():
		board_slot.connect("gui_input", self, "board_gui_input", [board_slot])
		
func slot_gui_input(event: InputEvent, slot: Slot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_chip != null:
				if !slot.chip: # empty slot
					slot.put_into_slot(holding_chip)
					holding_chip = null
				else: #slot with a chip --> swap
					var temp_chip = slot.chip
					slot.pick_from_slot()
					temp_chip.global_position = event.global_position
					slot.put_into_slot(holding_chip)
					holding_chip = temp_chip
			elif slot.chip:
				holding_chip = slot.chip
				slot.pick_from_slot()
				holding_chip.global_position = get_global_mouse_position()
			
			update_descrption()
				
func board_gui_input(event: InputEvent, chip_slot: ChipSlot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_chip != null and (chip_slot.special_skill == holding_chip.special_skill):
				if !chip_slot.chip: # empty slot
					chip_slot.put_into_board(holding_chip)
					holding_chip = null
				else: #slot with a chip --> swap
					var temp_chip = chip_slot.chip
					chip_slot.pick_from_board()
					temp_chip.global_position = event.global_position
					chip_slot.put_into_board(holding_chip)
					holding_chip = temp_chip
			elif holding_chip == null and chip_slot.chip:
				holding_chip = chip_slot.chip
				chip_slot.pick_from_board()
				holding_chip.global_position = get_global_mouse_position()
			
			update_descrption()

func _input(event):
	if holding_chip:
		holding_chip.global_position = get_global_mouse_position()
		
func update_descrption():
	if holding_chip:
		$DescriptionPanel/SkillInfo.set_text(holding_chip.description) 
	else:
		$DescriptionPanel/SkillInfo.set_text("") 
