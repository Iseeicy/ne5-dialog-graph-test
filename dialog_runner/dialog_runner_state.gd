extends BobboState
class_name DialogRunnerState

#
#	Variables
#

## The TextWindow that the dialog runner is using
var text_window: TextWindow:
	get:
		return _state_machine.text_window
