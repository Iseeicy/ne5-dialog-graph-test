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



