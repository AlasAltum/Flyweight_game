extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var base_pitch = 1.0
export(float) var max_pitch = 1.5

var max_buff = 0
var lPitch = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	max_buff = owner.get_node("StateMachine/Grab").MAX_BUFF_VALUE
	lPitch = max_pitch -  base_pitch
	
func update_pitch(buff_value):
	self.pitch_scale = base_pitch + (buff_value/max_buff) * lPitch
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
