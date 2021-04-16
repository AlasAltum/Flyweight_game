class_name Slot
extends Panel

var default_tex = preload("res://sprites/item_slot_default_background.png")
var empty_tex = preload("res://sprites/item_slot_empty_background.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var chip: Chip = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	
	if get_child_count() > 0:
		chip = get_child(0)
	refresh_style()

func pick_from_slot():
	remove_child(chip)
	var menu_node = find_parent("SkillMenu").get_node("HoldingChip")
	menu_node.add_child(chip)
	chip.set_to_board_position()
	chip.set_to_board_scale()
	chip = null
	refresh_style()
	
func put_into_slot(new_chip):
	chip = new_chip
	chip.set_to_slot_position()
	chip.set_to_slot_scale()
	var menu_node = find_parent("SkillMenu").get_node("HoldingChip")
	menu_node.remove_child(chip)
	add_child(chip)
	refresh_style()

func refresh_style():
	if chip == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)
