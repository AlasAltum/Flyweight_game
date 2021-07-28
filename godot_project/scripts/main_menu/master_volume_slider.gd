extends HSlider

export var audio_bus_name := "Master"
onready var _bus_index := LevelManager._bus_index


func _ready() -> void:
	LevelManager.master_audio_bus_name = audio_bus_name
	_on_MasterVolumeSlider_value_changed(-0.05)
	self.set_value(0.7)
	self.anchor_left = 110

# Cambia linealmente el audio según se modifica el hslide.
func _on_MasterVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(_bus_index, linear2db(value))
