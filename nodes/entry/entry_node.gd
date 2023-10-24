extends DialogGraphNode

#
#	Private Variables
#

var _data: EntryNodeData = EntryNodeData.new()

#
#	Public Functions
#

func get_node_data() -> GraphNodeData:
	return _data

func set_node_data(data: GraphNodeData) -> bool:
	# If this isn't the right type, exit early. Otherwise, cast correctly
	if not data is EntryNodeData:
		return false
	_data = data as EntryNodeData
	
	return true
