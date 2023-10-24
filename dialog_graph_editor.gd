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

#
#	Godot Functions
#

func _ready():
	for scene in node_scenes:
		var temp_node = scene.instantiate()
		_node_scene_by_name[temp_node.name] = scene
		temp_node.free()
	
	chose_node_scenes.emit(_node_scene_by_name)

#
#	Functions
#

func delete_node(node: GraphNode):
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
		var control: DialogGraphNode = data.get_control_scene().instantiate()
		$GraphEdit.add_child(control)
		control.position_offset = data.position
		control_by_id[id] = control
		control.set_node_data(data)
		
	# Actually connect the nodes
	# (conn is defined as follows:)
	##{ "from_id": int, "from_port": int, "to_id": int, "to_port": int }
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

#
#	Signals
#

func _on_add_node_spawn_node(scene: PackedScene):
	var new_node: GraphNode = scene.instantiate()
	
	# Update position to be middle of screen
	new_node.position_offset = $GraphEdit.scroll_offset
	new_node.position_offset += $GraphEdit.size / 2
	new_node.position_offset /= $GraphEdit.zoom
	
	# Tell the node to call our classes function when it wants
	# to be removed.
	var close_this_node = func():
		delete_node(new_node)
	new_node.close_request.connect(close_this_node.bind())
	
	
	$GraphEdit.add_child(new_node)

func _on_graph_edit_delete_nodes_request(nodes):
	for node_name in nodes:
		delete_node($GraphEdit.get_node(node_name as NodePath))

func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	# If the hovering node is already connected to something else, INGORE this
	if _is_node_port_connected(from_node, from_port):
		return
	
	$GraphEdit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	$GraphEdit.disconnect_node(from_node, from_port, to_node, to_port)



