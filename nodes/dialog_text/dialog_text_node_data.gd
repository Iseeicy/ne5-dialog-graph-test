@tool
extends GraphNodeData
class_name DialogTextNodeData
static var _control_scene: PackedScene = null

@export var text: Array[String] = []

#
#	Functions
#

func get_control_scene() -> PackedScene:
	if _control_scene == null:
		_control_scene = load("res://nodes/dialog_text/dialog_text_node.tscn")
	
	return _control_scene
