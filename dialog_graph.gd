extends Resource
class_name DialogGraph

#
#	Exports
#

## All of the nodes in the graph, stored by ID (int -> GraphNodeData)
@export var all_nodes: Dictionary = {
	0: EntryNodeData.new()
}

## A list of connections between the nodes in the graph in the form of
## { "from_id": int, "from_port": int, "to_id": int, "to_port": int }
@export var connections: Array[Dictionary] = []

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
		
	var connection = _create_connection_dict(from_id, from_port, to_id, to_port)
	connections.push_back(connection)
		
	return true
	

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
