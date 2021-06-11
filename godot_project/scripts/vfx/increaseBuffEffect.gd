extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("effect")
	pass # Replace with function body.


func delete_effect():
	self.queue_free()
