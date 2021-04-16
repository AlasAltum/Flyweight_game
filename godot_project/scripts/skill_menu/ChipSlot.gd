class_name ChipSlot
extends Panel

var chip: Chip = null
export(bool) var special_skill = false

signal activate_skill(skill_name, skill_value)
signal deactivate_skill(skill_name, skill_value)

func _ready():
	if chip == null:
		$AnimationPlayer.play("enabled")

func pick_from_board():
	emit_signal("deactivate_skill", chip.skill_name, chip.skill_value)
	$ChipShape/Shape.set_visible(true)
	$AnimationPlayer.play("enabled")
	$ChipPosition.remove_child(chip)
	var menu_node = find_parent("SkillMenu").get_node("HoldingChip")
	menu_node.add_child(chip)
	chip.set_to_board_position()
	chip.set_to_board_scale()
	chip = null
	
func put_into_board(new_chip):
	$ChipShape/Shape.set_visible(false)
	$AnimationPlayer.stop()
	chip = new_chip
	emit_signal("activate_skill", chip.skill_name, chip.skill_value)
	chip.set_to_board_position()
	chip.set_to_board_scale()
	var menu_node = find_parent("SkillMenu").get_node("HoldingChip")
	menu_node.remove_child(chip)
	$ChipPosition.add_child(chip)
