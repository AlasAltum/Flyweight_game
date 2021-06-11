extends TextureRect

onready var text_input = $ContinueOptionsOrganizer/CodeRow/TextEdit


func _on_ContinueButton_pressed():
	self.visible = true;

func _on_CloseContinueButton_pressed():
	self.visible = false;

func _on_EnterCodeButton_pressed():
	print(text_input.text)
	if LevelManager.try_level_by_code(text_input.text) == true:
		print('hola')
	else:
		print('invalid code')
