extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const max_lifes : int = 10

var dPeriod = 0
var dPersistance = 0
var dLacunarity = 0
var dColor : Color

const low_hp_period : int = 256
const hight_hp_period : int = 64
const low_hp_pers : float = 1.0
const hight_hp_pers : float = 0.3
const low_hp_lac : float = 0.1
const hight_hp_lac : float = 2.0

onready var noiseTexture : NoiseTexture = $batteryBar/lightTexture.texture
export(Color) var low_color = Color.red;
export(Color) var hight_color = Color.green;
export(int, 0, 10) onready var current_life setget setLife




# Called when the node enters the scene tree for the first time.
func _ready():
	dPeriod = (hight_hp_period - low_hp_period) / max_lifes
	dPersistance = (hight_hp_pers - low_hp_pers) / max_lifes
	dLacunarity = (hight_hp_lac - low_hp_lac) / max_lifes
	dColor = (hight_color - low_color) / max_lifes
	pass # Replace with function body.

func setNoise(period, persistence, lacunarity, color):
	if noiseTexture == null:
		return
	var new_noise = OpenSimplexNoise.new()
	new_noise.period = period
	new_noise.persistence = persistence
	new_noise.lacunarity = lacunarity
	noiseTexture.noise = new_noise
	
	$batteryBar/lightTexture.material.set_shader_param("color", color)
	$batteryBar/lightTexture.material.set_shader_param("border_color", color)

func setLife(life):
	if noiseTexture == null:
		return
	var tmp_period = low_hp_period + dPeriod * life
	var tmp_persistance = low_hp_pers + dPersistance*life
	var tmp_lacunarity = low_hp_lac + dLacunarity*life
	var tmp_color = low_color + dColor*life
	setNoise(tmp_period, tmp_persistance, tmp_lacunarity, tmp_color)
	
	if life == 0:
		noiseTexture.as_normalmap = true
	else:
		noiseTexture.as_normalmap = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
