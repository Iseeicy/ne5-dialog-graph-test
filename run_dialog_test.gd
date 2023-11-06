extends Control

#
#	Exports
#

@export var dialog: DialogGraph

#
#	Godot Functions
#

func _ready() -> void:
	$DialogRunner.run_dialog(dialog)

#
#	Signals
#

func _on_next_button_pressed():
	$DialogRunner.dialog_interact()
