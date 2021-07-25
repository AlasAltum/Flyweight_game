extends Area2D

#onready var player = get_node("Player")
export (Texture) var chip_texture;
onready var floating_chip := $FloatingChip as Sprite
onready var teleport_sound = $TeleportSound
onready var animation = $StationTexture/AnimationPlayer
onready var skill_menu = $SkillMenuLayer
var previous_motion
var powerUps = []


func _ready() -> void:
	# Solucion temporal para cerrar el menu luego de abrirlo con la tecla S
	floating_chip.texture = chip_texture;
	previous_motion = LevelManager.player.get_motion()
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	skill_menu.connect("continue_skill_menu", self, "_close_menu")

func on_body_entered(body: Node):
	previous_motion = LevelManager.player.get_motion()
	teleport_sound.play(0.0)
	animation.play("Station")
	get_tree().paused = true
	LevelManager.player.motion = Vector2.ZERO
	$FloatingChip/FloatingChipAnimation.play("Fade")
	

func activate_skill_menu():
	skill_menu.activate_skill_menu()

func _close_menu():
	if previous_motion:
		LevelManager.player.motion = previous_motion
	else:
		pass


func _on_FloatingChipAnimation_animation_finished(anim_name):
	if anim_name == "Fade":
		$FloatingChip.visible = false
