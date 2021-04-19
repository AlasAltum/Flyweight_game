extends MarginContainer

var memory_static

func _physics_process(delta):
	memory_static = stepify(Performance.get_monitor(Performance.MEMORY_STATIC) / (1024 * 1024), 0.01)
	$HBoxContainer/VBoxContainer/Stat01.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$HBoxContainer/VBoxContainer/Stat02.text = "Memory Static: " + str(memory_static) + " MB"
	
