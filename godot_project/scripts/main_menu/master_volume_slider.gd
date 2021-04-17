extends HSlider

export var audio_bus_name := "Master"
onready var _bus_index := AudioServer.get_bus_index(audio_bus_name)


func _ready() -> void:
	pass
	# value = db2linear(AudioServer.get_bus_volume_db(_bus_index))
	# TODO: hacer que se correlacione el nivel inicial con el volumen inicial.

# Cambia linealmente el audio según se modifica el hslide.
func _on_MasterVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(_bus_index, linear2db(value))
