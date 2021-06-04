extends Node2D


export(int) var damage = 1
export(float) var speed = 20

func _ready():
	pass


func _physics_process(delta):
	for body in $Body/Area2D.get_overlapping_bodies():
		if body is PlayerController:
			body.apply_damage(1)
	
	$Body.move_and_slide(Vector2(0,-20))
