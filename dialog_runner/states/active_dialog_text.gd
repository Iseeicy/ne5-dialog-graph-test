extends DialogRunnerActiveHandlerState

#
#	Public Variables
#

var text_data: DialogTextNodeData:
	get:
		return data as DialogTextNodeData
		
var index: int

#
#	State Functions
#

func state_enter(_message: Dictionary = {}) -> void:
	_get_parent_state().state_enter(_message)
	runner.dialog_interacted.connect(_on_dialog_interacted.bind())
	
	index = -1
	_display_next_text()
	
func state_exit() -> void:
	runner.dialog_interacted.disconnect(_on_dialog_interacted.bind())	
	_get_parent_state().state_exit()

#
#	Private Functions
#

func _display_next_text() -> void:
	index += 1
	
	# If we're out of text for this node, move on
	if index >= text_data.text.size():
		_go_to_next_node()
		return
	
	# OTHERWISE - show this text!
	text_window.show_dialog(TextWindowDialog.create_text(text_data.text[index]))

func _go_to_next_node() -> void:
	var connections = graph.get_connections_from(id)
	if connections.size() == 0:
		runner.stop_dialog()
	else:
		runner.go_to_node(connections[0].to_id)

#
#	Signals
#

func _on_dialog_interacted() -> void:
	_display_next_text()
