extends Area2D

onready var animation := $AnimatedSprite as AnimatedSprite

func _on_Gate_body_entered(body : KinematicBody2D):
	body.set_motion(Vector2(0, 0))
	body.visible = false
	get_tree().paused = true
	animation.play('Open')
	$AnimatedSprite/TeleportAudio.play()

func _on_AnimatedSprite_animation_finished():
	get_tree().paused = false
	LevelManager.next()
