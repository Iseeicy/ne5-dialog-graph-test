@tool
extends GraphNodeData
class_name ForwarderNodeData
static var _control_scene: PackedScene = null


#
#	Functions
#

func get_control_scene() -> PackedScene:
	if _control_scene == null:
		_control_scene = load("res://nodes/forwarder/forwarder_node.tscn")
	
	return _control_scene

func get_node_name() -> String:
	return "Forwarder"
