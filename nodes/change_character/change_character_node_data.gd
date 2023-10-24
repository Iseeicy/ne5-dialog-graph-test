@tool
extends GraphNodeData
class_name ChangeCharacterNodeData
static var _control_scene: PackedScene = null

#
#	Exports
#

@export var character_definition: CharacterDefinition = null

#
#	Functions
#

func get_control_scene() -> PackedScene:
	if _control_scene == null:
		_control_scene = load("res://nodes/change_character/change_character_node.tscn")
	
	return _control_scene
