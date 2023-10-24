extends Control

func _ready():
	$DialogGraphEditor.load_from_resource(DialogGraph.new())


func _on_save_button_pressed():
	var new_graph = DialogGraph.new()
	$DialogGraphEditor.save_to_resource(new_graph)
	ResourceSaver.save(new_graph, "res://test_graph.tres")
	

func _on_load_button_pressed():
	var graph = load("res://test_graph.tres")
	$DialogGraphEditor.load_from_resource(graph)
