extends Node2D

# Levels and cinematics
var mainMenu = preload("res://scenes/Menu.tscn")
var first_cinematic = preload("res://scenes/cinematics/intro_cinematic1.tscn")
var second_cinematic = preload("res://scenes/cinematics/intro_cinematic2.tscn")
var firstLevel = preload("res://scenes/first_level_dev.tscn")
var skillMenu = preload("res://prefabs/SkillMenuLayer.tscn")
var game_over_scene = preload("res://scenes/cinematics/Game Over.tscn")
var credits = preload("res://scenes/credits.tscn")


var levels = [mainMenu,
	first_cinematic,
	second_cinematic,
	firstLevel
]

# insert here level codes
var level_codes = {
	'level1': firstLevel,
	'credits': credits,
}



var current_level = 0
var current_world: Node = null
var loading = false
onready var world := $World as Node2D
onready var fade := $CanvasLayer/Fade as ColorRect 


func _ready():
	fade.connect("faded", self, "on_faded")
	current_world = levels[0].instance()
	world.add_child(current_world)
	levels = [mainMenu,
		first_cinematic,
		second_cinematic,
		firstLevel
	]

func change_scene(scene):
	var s = scene.instance()
	world.remove_child(current_world)
	current_world.queue_free()
	current_world = s
	current_level = levels.find(scene)
	world.add_child(current_world)

func add_scene(scene):
	get_tree().paused = true
	fade.fade_in()
	yield(fade, "faded")
	var s = load(scene).instance()
	world.add_child(s)
	fade.fade_out()

func remove_scene(scene_node):
	fade.fade_in()
	yield(fade, "faded")
	world.remove_child(scene_node)
	scene_node.queue_free()
	fade.fade_out()
	get_tree().paused = false

func next():
	current_level += 1
	if current_level >= levels.size():
		current_level = current_level % levels.size()
	loading = true
	fade.fade_in()

func on_faded():
	if loading:
		world.remove_child(current_world)
		current_world.queue_free()
		current_world = levels[current_level].instance()
		world.add_child(current_world)
		loading = false
		fade.fade_out()

func reset():
	self.change_scene(levels[current_level])

func load_code_level(code_text : String):
	if code_text in level_codes:
		self.change_scene(level_codes[code_text])

func change_scene_to_main_menu():
	self.change_scene(mainMenu)

func game_over():
	world.add_child(game_over_scene.instance())

func go_to_credits():
	self.change_scene(level_codes['credits'])
