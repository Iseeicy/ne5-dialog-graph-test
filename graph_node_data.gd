extends Resource
class_name GraphNodeData

#
#	Exports
#

@export var position: Vector2 = Vector2.ZERO

#
#	Virtual Functions
#

func get_control_scene() -> PackedScene:
	return null

func get_node_name() -> String:
	return ""
