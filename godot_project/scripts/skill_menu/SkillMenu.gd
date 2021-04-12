extends Node2D

onready var chips_slots = $GridContainer
var holding_chip = null

func _ready():
	for chip_slot in chips_slots.get_children():
		chip_slot.connect("gui_input", self, "slot_gui_input", [chip_slot])
		
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

func _input(event):
	if holding_chip:
		holding_chip.global_position = get_global_mouse_position()
