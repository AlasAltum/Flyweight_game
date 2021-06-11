extends Node

var player : PlayerController
onready var Game = get_tree().get_root().get_node("Game")

var checkpoint: Node setget set_checkpoint
func set_checkpoint(value):
	if checkpoint:
		checkpoint.off()
	checkpoint = value
	checkpoint.on()

func next():
	if !is_instance_valid(Game):
		Game = get_tree().get_root().get_node("Game")
	Game.next()

func change_scene(scene):
	Game.change_scene(scene)

func reset():
	Game.reset()

func add_scene(scene):
	Game.add_scene(scene)

func remove_scene(scene_node):
	Game.remove_scene(scene_node)

func try_level_by_code(code_text : String):
	return Game.charge_code_level(code_text)
