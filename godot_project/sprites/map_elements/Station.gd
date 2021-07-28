extends Area2D

#onready var player = get_node("Player")
export (Texture) var chip_texture;
export (String) var new_chip_path;
onready var floating_chip := $FloatingChip as Sprite
onready var teleport_sound = $TeleportSound
onready var animation = $StationTexture/AnimationPlayer
onready var skill_menu = $SkillMenuLayer
onready var first_time = true;

var previous_motion


func _ready() -> void:
	# Solucion temporal para cerrar el menu luego de abrirlo con la tecla S
	floating_chip.texture = chip_texture;
	previous_motion = LevelManager.player.get_motion()
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	skill_menu.connect("continue_skill_menu", self, "_close_menu")

func on_body_entered(body: Node):
	previous_motion = LevelManager.player.get_motion()
	LevelManager.player.motion = Vector2.ZERO
	teleport_sound.play(0.0)
	animation.play("Station")
	get_tree().paused = true
	
	if first_time:
		# Desaparece el chip y se encontrará entre las habilidades
		LevelManager.first_time_skills.append(
			$SkillMenuLayer.get_node(new_chip_path)
		)
		$FloatingChip/FloatingChipAnimation.play("Fade") # al final de esto aparece el menu
		first_time = false


func activate_skill_menu():
	skill_menu.activate_skill_menu()

func _close_menu():
	if previous_motion:
		LevelManager.player.motion = previous_motion


func _on_FloatingChipAnimation_animation_finished(anim_name):
	if anim_name == "Fade":
		$FloatingChip.visible = false
