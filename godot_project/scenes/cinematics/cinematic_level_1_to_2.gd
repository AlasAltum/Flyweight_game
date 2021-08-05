extends Node2D

onready var fade = $Fade

func _ready():
	fade.fade_out()

func _on_DialogueBox_dialogue_finished():
	$Control/DialogueBox.visible = false
	$workstation.visible = true
	$workstation/worktstationAnimation.play("workstation")
	

func _on_worktstationAnimation_animation_finished(anim_name):
	$workstation.visible = false
	$Control/DialogueBoxAfterWorkstation.visible = true
	$Control/DialogueBoxAfterWorkstation.start()

func _on_DialogueBoxAfterWorkstation_dialogue_finished():
	LevelManager.next()
