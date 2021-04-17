extends TextureRect

onready var closing_button = $CloseOptionsButton

func _ready():
	self.visible = false;

func _on_CloseOptionsButton_pressed():
	self.visible = false;

func _on_OptionsButton_pressed():
	self.visible = true;
