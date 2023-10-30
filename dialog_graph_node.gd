@tool
extends GraphNode
class_name DialogGraphNode

#
#	Public Variables
#

var descriptor: DialogGraphNodeDescriptor = null

#
#	Private Variables
#

var _data: GraphNodeData = null

#
#	Virtual Functions
#

func get_node_data() -> GraphNodeData:
	return _data

func set_node_data(data: GraphNodeData) -> GraphNodeData:
	_data = data
	return _data
