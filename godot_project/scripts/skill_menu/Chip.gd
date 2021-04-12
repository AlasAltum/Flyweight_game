class_name Chip
extends Node2D

var disabled_tex = preload("res://sprites/chip_none.png")
export (Texture) var enabled_tex

export(bool) var enabled = false
export(bool) var movement_skill = false

func _ready():
	refresh_texture()
	
func refresh_texture():
	if enabled:
		$TextureRect.set_texture(enabled_tex)
	else:
		$TextureRect.set_texture(disabled_tex)
