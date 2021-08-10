extends Node2D
var click = preload("res://prefabs/ClickAnim.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	parent = find_parent("Game")
	
func _input(event):
	if event.is_action_pressed("basic_jump") or event.is_action_pressed("skill"):
		$AnimationPlayer.play("hold")
		var clickInstance = click.instance()
		parent.add_child(clickInstance)
		clickInstance.position = parent.get_global_mouse_position()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = self.get_global_mouse_position()
