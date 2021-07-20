extends Node2D

onready var buttons_animation := $CanvasLayer/Buttons/ButtonsAppear as AnimationPlayer

func _ready():
	get_tree().paused = true
	$CanvasLayer/YouDied/GameOverAnimation.play("GameOverAnimation") 
	self.visible = true

func make_buttons_appear():
	buttons_animation.play("modulation")
	$CanvasLayer/Buttons.visible = true

func _on_GameOverAnimation_animation_finished(anim_name):
	self.make_buttons_appear()

func _on_RestartLevelButton_pressed():
	# Restart level
	LevelManager.reset()
	get_tree().paused = false
	self.queue_free()

func _on_MainMenuButton_pressed():
	# Return to main menu
	LevelManager.change_scene_to_main_menu()
	get_tree().paused = false
	self.queue_free()
