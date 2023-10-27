@tool
extends GraphNodeData
class_name ChoicePromptNodeData
static var _control_scene: PackedScene = null

@export var text: String = ""
@export var choices: Array[String] = []

#
#	Functions
#

func get_control_scene() -> PackedScene:
	if _control_scene == null:
		_control_scene = load("res://nodes/choice_prompt/choice_prompt_node.tscn")
	
	return _control_scene

func get_node_name() -> String:
	return "ChoicePrompt"
