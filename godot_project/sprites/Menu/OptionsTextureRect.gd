extends TextureRect

onready var text_input = $ContinueOptionsOrganizer/CodeRow/TextEdit


func _on_ContinueButton_pressed():
	self.visible = true;

func _on_CloseContinueButton_pressed():
	self.visible = false;

func _on_EnterCodeButton_pressed():
	if LevelManager.is_text_valid(text_input.text) == true:
		LevelManager.load_code_level(text_input.text)
	else:
		print('invalid code')
