class_name HealthBar
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_lifes = 0

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

onready var player := LevelManager.player as PlayerController
onready var noiseTexture : NoiseTexture = $batteryBar/lightTexture.texture
export(Color) var low_color = Color.red;
export(Color) var hight_color = Color.green;

var health : Health
var skill_names = ["Hook", "Air Dash"]
var skill_cooldowns = [1.0, 1.0]


# Called when the node enters the scene tree for the first time.
func _ready():
	health = player.health_object 
	max_lifes = health.max_health
	dPeriod = (hight_hp_period - low_hp_period) / max_lifes
	dPersistance = (hight_hp_pers - low_hp_pers) / max_lifes
	dLacunarity = (hight_hp_lac - low_hp_lac) / max_lifes
	dColor = (hight_color - low_color) / max_lifes
	health.connect("lives_increased",self,"_setLife")
	health.connect("lives_decreased",self,"_hurted")
	health.connect("lives_decreased_frozen",self,"_hurted")
	_setLife(health.health)
	$SkillName.text = skill_names[player.skill_index]
	$ProgressClock.value = 100
	pass # Replace with function body.

func setNoise(period, persistence, lacunarity, color : Color):
	if noiseTexture == null:
		return
	var new_noise = OpenSimplexNoise.new()
	new_noise.period = period
	new_noise.persistence = persistence
	new_noise.lacunarity = lacunarity
	noiseTexture.noise = new_noise
	var tmp = Vector2(color.r, color.g).normalized()
	var color_final = Color(tmp.x, tmp.y, 0, 1)
	
	$batteryBar/lightTexture.material.set_shader_param("color", color_final)
	$batteryBar/lightTexture.material.set_shader_param("border_color", color_final)
	#Cambiar colo de ojos del player
	player.get_node("Sprite").material.set_shader_param("eyesColor", color_final)

func _hurted(amount):
	$AnimationPlayer.play("hurt")
	_setLife(amount)

func _setLife(lifes):
	if noiseTexture == null:
		return
	var tmp_period = low_hp_period + dPeriod * lifes
	var tmp_persistance = low_hp_pers + dPersistance*lifes
	var tmp_lacunarity = low_hp_lac + dLacunarity*lifes
	var tmp_color = low_color + dColor*lifes
	setNoise(tmp_period, tmp_persistance, tmp_lacunarity, tmp_color)
	if lifes == 0:
		noiseTexture.as_normalmap = true
	else:
		noiseTexture.as_normalmap = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	var globals = get_node("/root/PlayerStatus")
	if globals.isSkillused == 1:
		$ProgressClock.value = 0
		globals.isSkillused = 2
	if globals.isSkillused == 2:
		$ProgressClock.value = $ProgressClock.value + 100/Engine.get_frames_per_second()
	if $ProgressClock.value >= 100:
		globals.isSkillused = 0 
		

func _on_Player_switch_skill():
	$SkillName.text = skill_names[player.skill_index]
