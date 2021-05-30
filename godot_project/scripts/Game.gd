extends Node2D

var mainMenu = preload("res://scenes/Menu.tscn")
var skillMenu = preload("res://prefabs/SkillMenuLayer.tscn")
var firstLevel = preload("res://scenes/Main.tscn")

var Levels = {'mainMenu': mainMenu,
	'firstLevel': firstLevel,
	}

var current_level = 0
var current_world: Node = null
var loading = false

onready var fade = $CanvasLayer/Fade


func _ready():
	print('ready game')
	fade.connect("faded", self, "on_faded")
	current_world = Levels['firstLevel'].instance()
	$World.add_child(current_world)
	print('ready game finalizado')
	
func change_scene(scene):
	var s = load(scene).instance()
	$World.remove_child(current_world)
	current_world.queue_free()
	current_world = s
	$World.add_child(current_world)

func add_scene(scene):
	get_tree().paused = true
	fade.fade_in()
	yield(fade, "faded")
	var s = load(scene).instance()
	$World.add_child(s)
	fade.fade_out()

func remove_scene(scene_node):
	fade.fade_in()
	yield(fade, "faded")
	$World.remove_child(scene_node)
	scene_node.queue_free()
	fade.fade_out()
	get_tree().paused = false

func next():
	if current_level + 1 >= Levels.size():
		return
	loading = true
	fade.fade_in()

func on_faded():
	if loading:
		$World.remove_child(current_world)
		current_world.queue_free()
		current_level += 1
		current_world = Levels[current_level].instance()
		$World.add_child(current_world)
		loading = false
		fade.fade_out()

func reset():
	current_level = -1
	loading = true
	fade.fade_in()
