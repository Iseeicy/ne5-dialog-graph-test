@tool
extends GraphNodeData
class_name EntryNodeData
static var _control_scene: PackedScene = null


#
#	Functions
#

func get_control_scene() -> PackedScene:
	if _control_scene == null:
		_control_scene = load("res://nodes/entry/entry_node.tscn")
	
	return _control_scene
