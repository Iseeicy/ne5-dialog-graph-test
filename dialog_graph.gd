@tool
extends Resource
class_name DialogGraph

#
#	Classes
#

class NodeConnection:
	var from_id: int
	var from_port: int
	var to_id: int
	var to_port: int

#
#	Exports
#

## All of the nodes in the graph, stored by ID (int -> GraphNodeData)
@export var all_nodes: Dictionary = {
	0: EntryNodeData.new()
}

## A list of connections between the nodes in the graph
@export var connections: Array = []

#
#	Private Variables
#

var _last_id: int = 0

#
#	Public Functions
#

func clear() -> void:
	all_nodes.clear()
	connections.clear()
	_last_id = -1

func add_node(data: GraphNodeData) -> int:
	var new_id = _get_next_id()
	all_nodes[new_id] = data
	return new_id

func contains_id(id: int) -> bool:
	return id in all_nodes

func connect_nodes(from_id: int, from_port: int, to_id: int, to_port: int) -> bool:
	if not contains_id(from_id) or not contains_id(to_id):
		return false
		
	var conn = NodeConnection.new()
	conn.from_id = from_id
	conn.from_port = from_port
	conn.to_id = to_id
	conn.to_port = to_port
	connections.push_back(conn)
		
	return true

func get_entry_id() -> int:
	for id in all_nodes.keys():
		var node = all_nodes[id]
		if node is EntryNodeData:
			return id
			
	return -1
	
func get_node_data(id: int) -> GraphNodeData:
	return all_nodes[id]
	
## Returns a list of all connections from or to the given node
func get_connections_to_and_from(id: int) -> Array:
	return connections.filter(
		func(conn): return conn.from_id == id or conn.to_id == id
	)

## Returns a list of all connections from the given node
func get_connections_from(id: int) -> Array:
	return connections.filter(
		func(conn): return conn.from_id == id
	)
	
## Returns a list of all connections to the given node
func get_connections_to(id: int) -> Array:
	return connections.filter(
		func(conn): return conn.to_id == id
	)
	
#
#	Private Functions
#

func _create_connection_dict(from_id: int, from_port: int, to_id: int, to_port: int) -> Dictionary:
	return {
		"from_id": from_id,
		"from_port": from_port,
		"to_id": to_id,
		"to_port": to_port
	}

func _init_last_id() -> int:
	if all_nodes.size() > 0:
		return all_nodes.keys().max()
	else:
		return 0

func _get_next_id() -> int:
	if _last_id == -1:
		_last_id = _init_last_id()
	
	_last_id += 1
	return _last_id	
