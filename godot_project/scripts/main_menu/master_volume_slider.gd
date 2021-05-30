extends HSlider

export var audio_bus_name := "Master"
onready var _bus_index := AudioServer.get_bus_index(audio_bus_name)


func _ready() -> void:
	_on_MasterVolumeSlider_value_changed(-0.05)
	self.set_value(0.5)
	self.anchor_left = 110

# Cambia linealmente el audio según se modifica el hslide.
func _on_MasterVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(_bus_index, linear2db(value))
