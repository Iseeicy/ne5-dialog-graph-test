extends DialogGraphNode

#
#	Private Variables
#

var _data: ChangeCharacterNodeData = ChangeCharacterNodeData.new()

#
#	Public Functions
#

func get_node_data() -> GraphNodeData:
	return _data

func set_node_data(data: GraphNodeData) -> bool:
	# If this isn't the right type, exit early. Otherwise, cast correctly
	if not data is ChangeCharacterNodeData:
		return false
	_data = data as ChangeCharacterNodeData
	
	# Set the UI fields
	$CharacterDefResourceField.set_target_resource(_data.character_definition)
	return true

func _on_character_def_resource_field_target_resource_updated(resource):
	_data.character_definition = resource
