extends DialogRunnerActiveHandlerState

#
#	Public Variables
#

var choice_data: ChoicePromptNodeData:
	get:
		return data as ChoicePromptNodeData

#
#	State Functions
#

func state_enter(_message: Dictionary = {}) -> void:
	_get_parent_state().state_enter(_message)
	
	# Construct the prompt to display in the text window
	var prompt = TextWindowChoicePrompt.create_prompt_with_text(
		choice_data.text, 
		choice_data.choices
	)
	
	text_window.show_choice_prompt(prompt)
	
func state_exit() -> void:
	_get_parent_state().state_exit()
