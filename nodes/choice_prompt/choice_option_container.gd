extends PanelContainer

#
#	Exports
#

signal settings_visibility_changed(is_visible: bool)

#
#	Private Variables
#

var _line_label: Label
var _settings_button: Button
var _settings_container: Control
var _settings_open = false

#
#	Godot Functions
#

func _ready():
	_line_label = $MarginContainer/VBoxContainer/OptionEditContainer/LineLabel
	_settings_button = $MarginContainer/VBoxContainer/OptionEditContainer/SettingsButton
	_settings_container = $MarginContainer/VBoxContainer/OptionSettingsContainer
	_set_settings_open(false)

#
#	Pulic Functions
#

func setup(index: int):
	_line_label.text = "%s:" % index

#
#	Private Functions
#

func _set_settings_open(is_open: bool):
	_settings_open = is_open
	_settings_container.visible = is_open
	
	if is_open:
		_settings_button.text = " ^ "
	else:
		_settings_button.text = " v "
	settings_visibility_changed.emit(is_open)

func _on_settings_button_pressed():
	_set_settings_open(!_settings_open)
