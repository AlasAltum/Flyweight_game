extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$AnimationPlayer.play("click")
	pass # Replace with function body.

func _on_timer_timeout():
	self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
