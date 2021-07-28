extends Node2D

onready var camera = $AnimationCamera
onready var camera_animation = $AnimationCamera/CameraAnimPlayer

func _on_Area2D_body_entered(body):
	if body == LevelManager.player:
		get_tree().paused = true
		camera_animation.play("ascending_smoke")

func _on_DialogueBox_dialogue_finished():
	camera.current = false
	LevelManager.player.player_camera.current = true
	queue_free()

func _on_event_tree_exiting():
	get_tree().paused = false
