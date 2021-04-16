extends Button

signal continue_skill_menu 

func _ready():
	connect("pressed", self, "_button_pressed")

func _button_pressed():
	var menu_node = find_parent("SkillMenu")
	menu_node.set_visible(false)
	emit_signal("continue_skill_menu")
