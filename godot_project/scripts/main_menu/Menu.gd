extends Node

onready var NewGameButton = $MainMenu/VBoxContainer/NewGameButton
onready var OptionsButton = $MainMenu/VBoxContainer/OptionsButton
onready var ExitButton = $MainMenu/VBoxContainer/ExitButton


func _ready():
	# Conecta señal para iniciar una nueva escena
	ExitButton.connect("pressed", self, "_on_ExitButton_pressed")

func _on_ExitButton_pressed():
	get_tree().quit()
