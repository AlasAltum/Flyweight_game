extends Node2D

onready var fade = $Fade

func _ready():
	fade.fade_out()

func _on_DialogueBox_dialogue_finished():
	LevelManager.next()
