extends Node
class_name DialoguePlayerA


signal dialogue_finished
var text : String = ''
var _conversation : Array
var _index_current : int = 0
var dialogue_file_path

func start(dialogue_dict : Dictionary) -> void:
	"""
	Sets the conversation as the values of the dictionary
	"""
	self.visible = true
	_conversation = dialogue_dict.values()
	_index_current = 0
	_update()

func next() -> void:
	_index_current += 1
	assert(_index_current <= _conversation.size())
	_update()

func _update() -> void:
	"""
	Updates Dialog box text. It may end the dialog.
	"""
	text = _conversation[_index_current].text
	if _index_current == _conversation.size() - 1:
		emit_signal('dialogue_finished')

