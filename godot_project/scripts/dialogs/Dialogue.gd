extends Control
class_name DialogueBox

signal event_after_dialogue_begin()
signal dialogue_finished()

export (String, FILE, "*.json") var dialogue_file_path : String


onready var dialogue_player: DialoguePlayer = $DialoguePlayer
onready var text_label : = $DialogText as Label
onready var button_next : = $DialogueBoxQuad/Panel/ButtonNext as Button
onready var animation_buttton = $DialogueBoxQuad/Panel/ButtonNext/ContinueButtonAnimation

var finished : bool = false

func _ready():
	dialogue_player.connect('dialogue_finished', self, '_on_dialogue_finished')
	var dialogue_dict = load_dialogue(dialogue_file_path)
	start(dialogue_dict)
	animation_buttton.play('ButtonMovement')

func start(dialogue : Dictionary) -> void:
	"""
	Initializes the dialogue
	"""
	button_next.show()
	button_next.grab_focus()
	dialogue_player.start(dialogue)
	update_content()
	show()

func load_dialogue(file_path : String) -> Dictionary:
	"""
	Parse a JSON file and returns it as a dictionary
	"""
	var file = File.new()
	assert(file.file_exists(file_path))
	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	return dialogue

func update_content() -> void:
	text_label.text = dialogue_player.text

func _on_ButtonNext_pressed():
	if not finished:
		dialogue_player.next()
		update_content()
	else:
		hide()
		emit_signal('event_after_dialogue_begin')

func _on_dialogue_finished():
	finished = true
	emit_signal('dialogue_finished')

func _on_ButtonSkip_pressed():
	# Al presionar se salta la cinemática
	emit_signal('dialogue_finished')
