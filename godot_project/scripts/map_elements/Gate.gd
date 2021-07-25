extends Area2D

onready var animations := $AnimatedSprite as AnimatedSprite

func _on_Gate_body_entered(body : KinematicBody2D):
	body.set_motion(Vector2(0, 0))
	body.visible = false
	get_tree().paused = true
	animations.play('Open')

func _on_AnimatedSprite_animation_finished():
	get_tree().paused = false
	LevelManager.next()
