extends Control

@export var dialog: DialogGraph

var _node_id: int = -1
var _is_in_text: bool = false

func _act_on_node(id: int) -> void:
	var data = dialog.get_node_data(id)
	
	if data is DialogTextNodeData:
		var text_data = data as DialogTextNodeData
		var dialog_text = text_data.text.map(
			func(text_str: String):
				return TextWindowDialog.create_text(text_str)
		)
		
		$DreamsOfBeingWindow.show_dialog(dialog_text)
	elif data is ForwarderNodeData:
		var conns = dialog.get_connections_from(id)
		if conns.size() == 0:
			_transition_to_node(-1)
		else:
			_transition_to_node(conns[0].to_id)

func _end_dialog() -> void:
	_node_id = -1
	$DreamsOfBeingWindow.close()

func _transition_to_node(id: int) -> void:
	if id == -1:
		_end_dialog()
		return
	
	_node_id = id
	_act_on_node(id)

func _on_next_button_pressed():
	# If we haven't started the dialog yet, START IT
	if _node_id == -1:
		_transition_to_node(dialog.get_entry_id())
		return
		
	var connections = dialog.get_connections_from(_node_id)
	
	# If there's no dialog left, END THIS SEQUENCE
	if connections.size() == 0:
		_end_dialog()
		return
		
	# Choose which path to take (for now we default to the first one)
	var conn = connections[0]
	_transition_to_node(conn.to_id)
