extends ConfirmationDialog
class_name QuickFindDialog

signal confirmed_path(path: String)

var _selected_path: String = ""

func _ready():
	confirmed.connect(_on_confirmed.bind())
	get_ok_button().disabled = true


func get_selected_path() -> String:
	return _selected_path

func _on_confirmed() -> void:
	confirmed_path.emit(_selected_path)

func _on_resource_search_list_item_selected(index: int):
	get_ok_button().disabled = false
	_selected_path = $VBoxContainer/ResourceSearchList.get_item_text(index)

