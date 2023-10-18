extends GraphNode

#
#	Exports
#

@export var text_edit_scene: PackedScene

#
#	Variables
#

@onready var _starting_size: Vector2 = size 
var _text_edits: Array[TextEdit] = []

#
#	Signals
#

func _on_remove_line_button_pressed():
	if _text_edits.size() == 0:
		return

	var old_text_edit = _text_edits.pop_back()
	old_text_edit.free()
	size = _starting_size

func _on_add_line_button_pressed():
	var new_text_edit = text_edit_scene.instantiate()
	$TextContainer.add_child(new_text_edit)
	_text_edits.push_back(new_text_edit)
