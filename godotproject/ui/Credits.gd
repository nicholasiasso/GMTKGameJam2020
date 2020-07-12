extends VBoxContainer

var select_suffix: String = "\n^"

var options: Array = []
var curr_index: int = 0

signal menu_option_selected(option)

# Called when the node enters the scene tree for the first time.
func _ready():
	options = get_tree().get_nodes_in_group("CreditsMenuText")

func set_selected(label: Label) -> void:
	var text = label.text
	if !text.ends_with(select_suffix):
		text += select_suffix
	label.text = text

func set_unselected(label: Label) -> void:
	var text = label.text
	text = text.trim_suffix(select_suffix)
	label.text = text

func _input(event):
	if !self.visible:
		return
	
	if event.is_action_pressed("ui_accept"):
		var selected = options[curr_index].text.trim_suffix(select_suffix).to_lower()
		emit_signal("menu_option_selected", selected)
		if (selected.begins_with("code")):
			OS.shell_open("https://github.com/nicholasiasso/GMTKGameJam2020")
		elif (selected.begins_with("music")):
			OS.shell_open("https://soundcloud.com/user-701036833")
		
		return
	
	var diff: int = 0;
	if (event.is_action_pressed("right")):
		diff = 1
	if (event.is_action_pressed("left")):
		diff = -1
	
	self.curr_index += diff
	if (curr_index < 0):
		curr_index = 0
	elif (curr_index > options.size() - 1) :
		curr_index = options.size() - 1
	
	for i in range(options.size()):
		var menu_label : Label = options[i]
		if (i == curr_index):
			set_selected(menu_label)
		else:
			set_unselected(menu_label)
