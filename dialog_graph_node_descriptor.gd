@tool
extends Resource
class_name DialogGraphNodeDescriptor

#
#	Exports
#

## The scene containing the visual GraphNode for GraphEdit that represents this
## node type. 
@export var graph_node_scene: PackedScene = null

## The scene containing the DialogRunnerActiveHandlerState that will handle
## performing actions as a result of encountering this node type in the graph.
@export var node_handler_scene: PackedScene = null
