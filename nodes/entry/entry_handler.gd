extends DialogRunnerActiveHandlerState

#
#	State Functions
#

func state_enter(_message: Dictionary = {}) -> void:
	_get_parent_state().state_enter(_message)
	call_deferred("_go_to_next_node")
	
func state_exit() -> void:
	_get_parent_state().state_exit()

#
#	Private Functions
#

func _go_to_next_node():
	# Get the connections to this entry node
	var connections = graph.get_connections_from(id)
	
	# If there are NO connections, stop 
	if connections.size() == 0:
		runner.stop_dialog()
		return
	
	# AT THIS POINT - we have at least one connection - so transition to the first one
	runner.go_to_node(connections[0].to_id)
