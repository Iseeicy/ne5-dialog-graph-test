extends DialogRunnerState
class_name DialogRunnerActiveHandlerState

#
#	Public Variables
#

var id: int:
	get:
		return _get_parent_state().get_node_id()

var data: GraphNodeData:
	get:
		return _get_parent_state().get_node_data()

