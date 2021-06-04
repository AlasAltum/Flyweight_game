extends Control

onready var NewGameButton = $MainButtons/NewGameButton
onready var OptionsButton = $MainButtons/OptionsButton
onready var ExitButton = $MainButtons/ExitButton


# Cuando se detecte la señal del botón presionado, cambie la escena.
func _on_NewGameButton_pressed():
	print('yapo levelmanager qlo pasa de nivel')
	LevelManager.next()

func _on_ExitButton_pressed():
	get_tree().quit()
