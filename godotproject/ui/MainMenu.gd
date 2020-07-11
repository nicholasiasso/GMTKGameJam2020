extends MarginContainer

var select_prefix: String = ">- "
var select_sufffix: String = " -<"

var options: Array = []
var curr_index: int = 0

signal menu_option_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	options = get_tree().get_nodes_in_group("MainMenuText")


func set_selected(label: Label) -> void:
	var text = label.text
	if !text.begins_with(select_prefix):
		text = select_prefix + text + select_sufffix
	label.text = text

func set_unselected(label: Label) -> void:
	var text = label.text
	text = text.trim_prefix(select_prefix).trim_suffix(select_sufffix)
	label.text = text

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("menu_option_selected")
		return
	
	var diff: int = 0;
	if (event.is_action_pressed("down")):
		diff = 1
	if (event.is_action_pressed("up")):
		diff = -1
	
	self.curr_index += diff
	if (curr_index < 0):
		curr_index = 0
	elif (curr_index > options.size() - 1) :
		curr_index = options.size() - 1
		
	print(curr_index)
	
	for i in range(options.size()):
		var menu_label : Label = options[i]
		if (i == curr_index):
			set_selected(menu_label)
		else:
			set_unselected(menu_label)

