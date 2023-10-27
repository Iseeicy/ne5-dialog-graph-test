extends Label


func _on_dialog_runner_transitioned(_state, path):
	text = "Current state: %s" % path
