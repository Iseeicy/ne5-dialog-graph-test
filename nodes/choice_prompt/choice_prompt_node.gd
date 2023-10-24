extends DialogGraphNode

#
#	Exports
#

@export var choice_option_scene: PackedScene

#
#	Variables
#

var _data: ChoicePromptNodeData = ChoicePromptNodeData.new()
@onready var _starting_size: Vector2 = size 
var _choice_options: Array[ChoicePromptOptionContainer] = []

#
#	Public Functions
#

func get_node_data() -> GraphNodeData:
	return _data

func set_node_data(data: GraphNodeData) -> bool:
	# If this isn't the right type, exit early. Otherwise, cast correctly
	if not data is ChoicePromptNodeData:
		return false
	_data = data as ChoicePromptNodeData
	
	# Remove any choices that exist
	for option in _choice_options:
		_free_option_control(option)
	_choice_options.clear()	
	
	for choice in _data.choices:
		var new_option = _new_option_control()
		_choice_options.push_back(new_option)
		new_option.set_text(choice)
	
	_update_size()
	return true

#
#	Private Functions
#

func _update_size():
	size = _starting_size

func _add_new_option() -> void:
	var new_option = _new_option_control()
	_choice_options.push_back(new_option)	
	_data.choices.push_back("")

func _remove_last_option() -> void:
	if _choice_options.size() == 0:
		return

	var old_option = _choice_options.pop_back()
	_free_option_control(old_option)
	_data.choices.pop_back()
	
func _new_option_control() -> ChoicePromptOptionContainer:
	var new_option = choice_option_scene.instantiate()
	add_child(new_option)
	
	var this_index = _choice_options.size()
	new_option.setup(this_index)
	set_slot(this_index + 1, false, 0, Color.CYAN, true, 0, Color.YELLOW)
	
	# Hook into the option container's signal that fires
	# when the settings panel is opened and closed,
	# becaues we need to adjust the size of this when
	# the size of the option changes.
	new_option.settings_visibility_changed.connect(
		_on_settings_visibility_changed.bind()
	)
	
	var text_changed_function = func(new_text: String):
		_on_text_changed(this_index, new_text)
	new_option.text_changed.connect(text_changed_function.bind())
	return new_option
	
func _free_option_control(old_option: ChoicePromptOptionContainer) -> void:
	var this_index = _choice_options.size()
	set_slot(this_index + 1, this_index == 0, 0, Color.CYAN, false, 0, Color.YELLOW)
	
	old_option.settings_visibility_changed.disconnect(
		_on_settings_visibility_changed.bind()
	)
	old_option.queue_free()
	old_option.visible = false
	_update_size()
	
	
#
#	Signals
#

func _on_remove_line_button_pressed():
	_remove_last_option()

func _on_add_line_button_pressed():
	_add_new_option()

func _on_settings_visibility_changed(_is_visible: bool):
	_update_size()
	
func _on_text_changed(index: int, new_text: String) -> void:
	_data.choices[index] = new_text
