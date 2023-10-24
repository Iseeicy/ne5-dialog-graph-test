@tool
extends DialogGraphNode

#
#	Exports
#

@export var text_edit_scene: PackedScene

#
#	Variables
#

var _data: DialogTextNodeData = DialogTextNodeData.new()
@onready var _starting_size: Vector2 = size 
var _text_edits: Array[TextEdit] = []

#
#	Public Functions
#

func get_node_data() -> GraphNodeData:
	return _data

func set_node_data(data: GraphNodeData) -> bool:
	# If this isn't the right type, exit early. Otherwise, cast correctly
	if not data is DialogTextNodeData:
		return false
	_data = data as DialogTextNodeData
	
	# Clear any old edits
	for edit in _text_edits:
		_free_edit_control(edit)
	_text_edits.clear()
	
	# Add controls for new texts
	for single_text in _data.text:
		var new_edit = _new_edit_control()
		_text_edits.push_back(new_edit)
		new_edit.text = single_text
	
	return true

#
#	Private Functions
#

func _add_new_edit() -> void:
	var new_edit = _new_edit_control()
	_text_edits.push_back(new_edit)
	_data.text.push_back("")

func _remove_last_edit() -> void:
	if _text_edits.size() == 0:
		return
	
	var old_edit = _text_edits.pop_back()
	_free_edit_control(old_edit)
	_data.text.pop_back()

func _new_edit_control() -> TextEdit:
	var new_edit = text_edit_scene.instantiate()
	$TextContainer.add_child(new_edit)
	
	var this_index = _text_edits.size()
	var text_changed_func = func():
		_on_text_changed(this_index, new_edit.text)
	new_edit.text_changed.connect(text_changed_func.bind())
	
	return new_edit
	
func _free_edit_control(old_edit: TextEdit) -> void:
	old_edit.queue_free()
	size = _starting_size

#
#	Signals
#

func _on_remove_line_button_pressed():
	_remove_last_edit()

func _on_add_line_button_pressed():
	_add_new_edit()
	
func _on_text_changed(index: int, new_text: String) -> void:
	_data.text[index] = new_text
