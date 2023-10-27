@tool
extends VBoxContainer
class_name DialogGraphEditor

#
#	Exports
#

signal chose_node_scenes(scenes_by_name: Dictionary)

## The graph nodes to allow spawning for
@export var node_scenes: Array[PackedScene] = []

#
#	Private Variables
#

## All node scenes stored by their name (String -> PackedScene)
var _node_scene_by_name: Dictionary = {}
var _selected_nodes: Array[DialogGraphNode] = []
var _preview_text_panel: Control
var _text_reader: TextReader

#
#	Godot Functions
#

func _ready():
	_preview_text_panel = $GraphEdit/PreviewTextWindow
	_text_reader = $GraphEdit/PreviewTextWindow/MarginContainer/TextReaderLabel/TextReader
	
	for scene in node_scenes:
		var temp_node = scene.instantiate()
		_node_scene_by_name[temp_node.name] = scene
		temp_node.free()
	
	chose_node_scenes.emit(_node_scene_by_name)

#
#	Functions
#

func delete_node(node: GraphNode):
	var connections_to_remove = []
	
	# Save all connections that reference this node. conn is in the form of
	# { from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }.
	for conn in $GraphEdit.get_connection_list():
		if conn.from == node.name or conn.to == node.name:
			connections_to_remove.push_back(conn)
			
	# Actually remove all of those saved connections
	for conn in connections_to_remove:
		$GraphEdit.disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
	
	node.queue_free()

func save_to_resource(dialog_graph: DialogGraph) -> void:
	dialog_graph.clear()
	var name_to_id: Dictionary = {}
	
	# Add graph data to the graph, noting which node names correspond
	# to what ID
	for child in $GraphEdit.get_children():
		if not (child is DialogGraphNode):
			continue
			
		var node_data = child.get_node_data()
		node_data.position = child.position_offset
		
		var id = dialog_graph.add_node(node_data)
		name_to_id[child.name] = id
	
	# Get connections in the form of:
	# { from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }
	for connection in $GraphEdit.get_connection_list():
		var from_id: int = name_to_id[connection.from]
		var to_id: int = name_to_id[connection.to]
		dialog_graph.connect_nodes(from_id, connection.from_port, to_id, connection.to_port)

func load_from_resource(dialog_graph: DialogGraph) -> void:
	# Clean out the existing graph edit
	$GraphEdit.clear_connections()
	for child in $GraphEdit.get_children():
		if not (child is DialogGraphNode):
			continue
		child.queue_free()
	
	# Deselect all nodes
	_selected_nodes.clear()
	_update_selected_nodes()
	
	if dialog_graph == null:
		return
	
	# Stores spawned controls by their ID (int -> DialogGraphNode)
	var control_by_id: Dictionary = {}
	
	# Create the controls for each node
	for id in dialog_graph.all_nodes.keys():
		var data: GraphNodeData = dialog_graph.all_nodes[id]
		
		if data.get_control_scene() == null:
			printerr("Couldn't find control for %s" % data)
			continue
			
		# Spawn the control, add it to the dict, and make it represent
		# this data
		var control: DialogGraphNode = _spawn_node(data.get_control_scene())
		control.position_offset = data.position
		control_by_id[id] = control
		control.set_node_data(data)
		
	# Actually connect the nodes
	for conn in dialog_graph.connections:
		# Get the nodes with these IDs
		var from_node = control_by_id[conn.from_id]
		var to_node = control_by_id[conn.to_id]
		
		# ...and connect em in the graph edit!
		$GraphEdit.connect_node(
			from_node.name, conn.from_port, 
			to_node.name, conn.to_port
		)
	
	

#
#	Private Functions
#

func _is_node_port_connected(node_name: String, port: int) -> bool:
	# Get connections in the form of:
	# { from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }
	for connection in $GraphEdit.get_connection_list():
		if connection.from_port != port:
			continue
		if connection.from != node_name:
			continue
		
		return true
	return false

func _spawn_node(node_scene: PackedScene) -> GraphNode:
	var new_node: GraphNode = node_scene.instantiate()
	
	# Tell the node to call our classes function when it wants
	# to be removed.
	var close_this_node = func():
		delete_node(new_node)
	new_node.close_request.connect(close_this_node.bind())
	
	$GraphEdit.add_child(new_node)
	return new_node

func _get_last_text_from_selected_nodes():
	var last_text = null
	
	for node in _selected_nodes:
		if not node.get_node_data() is DialogTextNodeData:
			continue
			
		var data = node.get_node_data() as DialogTextNodeData
		last_text = data.text
	
	return last_text

func _update_selected_nodes() -> void:
	var last_text = _get_last_text_from_selected_nodes()
	
	if _selected_nodes.size() > 0 and last_text != null and last_text.size() > 0:
		_preview_text_panel.visible = true
		_text_reader.start_reading(last_text[0])
	else:
		_text_reader.cancel_reading()
		_preview_text_panel.visible = false
		

#
#	Signals
#

func _on_add_node_spawn_node(scene: PackedScene):
	var new_node: GraphNode = _spawn_node(scene)
	
	# Update position to be middle of screen
	new_node.position_offset = $GraphEdit.scroll_offset
	new_node.position_offset += $GraphEdit.size / 2
	new_node.position_offset /= $GraphEdit.zoom
	
func _on_graph_edit_delete_nodes_request(nodes):
	for node_name in nodes:
		var node_to_delete = $GraphEdit.get_node(node_name as NodePath) 
		delete_node(node_to_delete)
		_on_graph_edit_node_deselected(node_to_delete)
		
func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	# If the hovering node is already connected to something else, INGORE this
	if _is_node_port_connected(from_node, from_port):
		return
	
	$GraphEdit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	$GraphEdit.disconnect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_node_selected(node):
	_selected_nodes.push_back(node)
	_update_selected_nodes()

func _on_graph_edit_node_deselected(node):
	_selected_nodes.erase(node)
	_update_selected_nodes()
