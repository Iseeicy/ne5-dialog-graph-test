extends BobboStateMachine
class_name DialogRunner

#
#	Exports
#

## The window to use when displaying dialog text and choice prompts
@export var text_window: TextWindow

#
#	Private Variables
#

var _current_dialog: DialogGraph = null

#
#	Public Functions
#

## Starts running a given dialog graph. If entry node param is not provided, dialog will start
## from the graph's entry node.
func run_dialog(dialog: DialogGraph, entry_node_id: int = -1) -> void:
	# If dialog is already running, stop it first!
	if is_running():
		stop_dialog()
	
	_current_dialog = dialog
	
	return
	
## Skips to the given node in the currently running dialog graph.
## If the node could not be found, or if there is no dialog graph running, this returns false.
## OTHERWISE, this returns true.
func go_to_node(node_id: int) -> bool:
	return false
	
## Are we currently running a dialog graph?
func is_running() -> bool:
	if state == null:
		return false
		
	return state.get_state_path().begins_with("Active")

## Stops running the current dialog graph.
## If there is no graph running, returns false.
## OTHERWISE, returns true.
func stop_dialog() -> bool:
	return false
