@tool
extends PopupMenu

#
#	Exports
#

## Emitted when a node is chosen from the popup menu
signal spawn_node(desc: DialogGraphNodeDescriptor)

#
#	Godot Functions
#

func _ready():
	await get_tree().root.ready
	id_pressed.connect(_on_id_pressed.bind())
	
	clear()
	for x in range(0, GraphNodeDB.descriptors.size()):
		if GraphNodeDB.descriptors[x].is_spawnable:
			add_item(GraphNodeDB.descriptors[x].node_name, x)

#
#	Signals
#

func _on_id_pressed(id: int) -> void:
	spawn_node.emit(GraphNodeDB.descriptors[id])

func _on_graph_edit_popup_request(req_pos):
	position = req_pos
	self.popup()


func _on_graph_edit_connection_to_empty(_from_node, _from_port, release_position):
	position = release_position
	self.popup()


func _on_graph_edit_connection_from_empty(_to_node, _to_port, release_position):
	position = release_position
	self.popup()
