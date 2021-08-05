extends Node2D


func _on_Area2D_body_entered(body):
	get_tree().paused = true
	$CanvasLayer/DialogueBox.start()


func _on_DialogueBox_dialogue_finished():
	get_tree().paused = false
