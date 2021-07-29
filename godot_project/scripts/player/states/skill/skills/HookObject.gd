extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if owner.get_node("StateMachine/Skill").get("current_skill").get_name()  == "Hook":
		visible = true
	else: 
		visible = false
