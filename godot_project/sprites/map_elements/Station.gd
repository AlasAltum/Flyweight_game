extends Area2D


onready var teleport_sound = $TeleportSound
onready var animation = $StationTexture/AnimationPlayer
onready var skill_menu = $SkillMenuLayer
onready var first_time = true;

var previous_motion


func _ready() -> void:
	# Solucion temporal para cerrar el menu luego de abrirlo con la tecla S
	previous_motion = LevelManager.player.get_motion()
	connect("body_entered", self, "on_body_entered")
	#connect("body_exited", self, "on_body_exited")
	skill_menu.connect("continue_skill_menu", self, "_close_menu")

func on_body_entered(body: Node):
	previous_motion = LevelManager.player.get_motion()
	LevelManager.player.motion = Vector2.ZERO
	teleport_sound.play(0.0)
	animation.play("Station")
	get_tree().paused = true


func activate_skill_menu():
	skill_menu.activate_skill_menu()

func _close_menu():
	if previous_motion:
		LevelManager.player.motion = previous_motion
