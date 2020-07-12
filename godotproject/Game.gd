extends Node2D

func _ready() -> void:
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)

func start_game() -> void:
	var world = load("res://levels/World.tscn").instance()
	$MainMenu.visible = false
	$MainMenu.queue_free()
	self.add_child(world)

func back_to_menu_from_credits() -> void:
	$Credits.visible = false
	$Credits.queue_free()
	var menu = load("res://ui/MainMenu.tscn").instance()
	menu.margin_top = 60
	self.add_child(menu)
	menu.connect("menu_option_selected", self, "_on_MainMenu_menu_option_selected")
	
func back_to_menu_from_options() -> void:
	$Options.visible = false
	$Options.queue_free()
	var menu = load("res://ui/MainMenu.tscn").instance()
	menu.margin_top = 60
	self.add_child(menu)
	menu.connect("menu_option_selected", self, "_on_MainMenu_menu_option_selected")

func display_credits() -> void:
	var credits = load("res://ui/Credits.tscn").instance()
	credits.margin_left = 50
	credits.margin_top = 15
	self.add_child(credits)
	$MainMenu.visible = false
	$MainMenu.queue_free()
	credits.connect("menu_option_selected", self, "_on_Credits_menu_option_selected")
	
func display_options() -> void:
	var options = load("res://ui/Options.tscn").instance()
	options.margin_left = 75
	options.margin_top = 25
	options.margin_right = 245
	options.margin_bottom = 150
	self.add_child(options)
	$MainMenu.visible = false
	$MainMenu.queue_free()
	options.connect("menu_option_selected", self, "_on_Options_menu_option_selected")
	options.connect("vol_adjust", self, "_on_Options_vol_adjust")
	get_tree()

func _on_MainMenu_menu_option_selected(option):
	option = option.to_lower()
	if option.begins_with("play"):
		start_game()
	if option.begins_with("options"):
		display_options()
	elif option.begins_with("credits"):
		display_credits()

func _on_Credits_menu_option_selected(option):
	option = option.to_lower()
	if option.begins_with("back"):
		back_to_menu_from_credits()

func _on_Options_menu_option_selected(option):
	option = option.to_lower()
	if option.begins_with("back"):
		back_to_menu_from_options()

func _on_Options_vol_adjust(value):
	if value == 0:
		$AudioStreamPlayer.stream_paused = true
	else:
		$AudioStreamPlayer.stream_paused = false
		#Default dbs is -12
		var dbs: int = -12
		if value < 7:
			dbs -= (7-value) * 2
		elif value > 7:
			dbs += (value-7) * 2
		print(dbs)
		$AudioStreamPlayer.volume_db = dbs
