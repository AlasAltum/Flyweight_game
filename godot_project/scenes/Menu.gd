extends Control


func _ready():
	var NewGameButton = $VBoxContainer/NewGameButton
	var OptionsButton = $VBoxContainer/OptionsButton
	var ExitButton = $VBoxContainer/ExitButton
	# Conecta señal para iniciar una nueva escena
	NewGameButton.connect("pressed", self, "_on_NewGameButton_pressed", [NewGameButton.scene_to_load])
	OptionsButton.connect("pressed", self, "_on_OptionsButton_pressed")
	ExitButton.connect("pressed", self, "_on_ExitButton_pressed")

	
# Cuando se detecte la señal del botón presionado, cambie la escena.
func _on_NewGameButton_pressed(scene_to_load : PackedScene):
	get_tree().change_scene_to(scene_to_load)

func _on_OptionsButton_pressed():
	pass

func _on_ExitButton_pressed():
	get_tree().quit()