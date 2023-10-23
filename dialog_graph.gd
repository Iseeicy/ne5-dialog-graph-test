extends Resource
class_name DialogGraph

#
#	Exports
#

## All of the nodes in the graph, stored by ID (int -> GraphNodeData)
@export var all_nodes: Dictionary = {}

#
#	Private Variables
#

var _last_id: int = -1

#
#	Private Functions
#

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
