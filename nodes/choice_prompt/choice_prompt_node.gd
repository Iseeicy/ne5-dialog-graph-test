extends GraphNode

#
#	Exports
#

@export var choice_option_scene: PackedScene

#
#	Variables
#

@onready var _starting_size: Vector2 = size 
var _choice_options: Array[Control] = []

#
#	Signals
#

func _on_remove_line_button_pressed():
	if _choice_options.size() == 0:
		return

	var old_option = _choice_options.pop_back()
	old_option.settings_visibility_changed.disconnect(
		_on_settings_visibility_changed.bind()
	)
	old_option.free()
	size = _starting_size

func _on_add_line_button_pressed():
	var new_option = choice_option_scene.instantiate()
	$OptionContainer.add_child(new_option)
	_choice_options.push_back(new_option)
	new_option.setup(_choice_options.size() - 1)
	
	# Hook into the option container's signal that fires
	# when the settings panel is opened and closed,
	# becaues we need to adjust the size of this when
	# the size of the option changes.
	new_option.settings_visibility_changed.connect(
		_on_settings_visibility_changed.bind()
	)

func _on_settings_visibility_changed(_is_visible: bool):
	size = _starting_size
