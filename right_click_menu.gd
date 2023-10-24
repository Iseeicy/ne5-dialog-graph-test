@tool
extends PopupMenu

#
#	Exports
#

## Emitted when a node is chosen from the popup menu
signal spawn_node(scene: PackedScene)

#
#	Private Variables
#

## Nodes stored by their ID in the popup (int -> PackedScene)
var _node_scenes_by_id: Dictionary = {}
var _node_scenes_by_name: Dictionary = {}

#
#	Godot Functions
#

func _ready():
	await get_tree().root.ready
	id_pressed.connect(_on_id_pressed.bind())
	
	clear()
	_node_scenes_by_id.clear()
	
	var _last_id = 0
	for scene in _node_scenes_by_name.values():
		var temp_instance = scene.instantiate()
		
		add_item(temp_instance.name, _last_id)
		_node_scenes_by_id[_last_id] = scene
		
		_last_id += 1
		temp_instance.free()

#
#	Signals
#

func _on_id_pressed(id: int) -> void:
	spawn_node.emit(_node_scenes_by_id[id])

func _on_dialog_graph_editor_chose_node_scenes(scenes: Dictionary):
	_node_scenes_by_name = scenes
	
func _on_graph_edit_popup_request(req_pos):
	position = req_pos
	self.popup()


func _on_graph_edit_connection_to_empty(_from_node, _from_port, release_position):
	position = release_position
	self.popup()


func _on_graph_edit_connection_from_empty(_to_node, _to_port, release_position):
	position = release_position
	self.popup()
