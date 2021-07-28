class_name Chip
extends Node2D

var disabled_tex = preload("res://sprites/chip_none.png")
export (Texture) var enabled_tex

export(bool) var enabled = false
export(bool) var special_skill = false

var slot_position : Vector2
var slot_scale : Vector2
export(String) var description = "None"
export(String) var skill_name = "None"
export(float) var skill_value = 0
export(Vector2) var board_position = Vector2(0, 0)
export(Vector2) var board_scale = Vector2(1.7, 1.7)

func _ready():
	self.visible = false
	slot_position = position
	slot_scale = scale
	refresh_texture()
	
func set_to_slot_position():
	position = slot_position

func set_to_slot_scale():
	scale = slot_scale
	
func set_to_board_position():
	position = board_position
	
func set_to_board_scale():
	scale = board_scale

func refresh_texture():
	if enabled:
		$TextureRect.set_texture(enabled_tex)
	else:
		$TextureRect.set_texture(disabled_tex)
		
func appear_texture():
	self.visible = true
	get_parent().visible = true
	$ChipAppear.play("ChipAppear")
