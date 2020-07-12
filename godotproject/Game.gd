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
	
func back_to_menu() -> void:
	$Credits.visible = false
	$Credits.queue_free()
	var menu = load("res://ui/MainMenu.tscn").instance()
#	menu.margin_left = 50
	menu.margin_top = 60
	self.add_child(menu)
	menu.connect("menu_option_selected", self, "_on_MainMenu_menu_option_selected")

func display_credits() -> void:
	print("display credits")
	var credits = load("res://ui/Credits.tscn").instance()
	credits.margin_left = 50
	credits.margin_top = 15
	self.add_child(credits)
	$MainMenu.visible = false
	$MainMenu.queue_free()
	credits.connect("menu_option_selected", self, "_on_Credits_menu_option_selected")

func _on_MainMenu_menu_option_selected(option):
	option = option.to_lower()
	if option.begins_with("play"):
		start_game()
	elif option.begins_with("credits"):
		display_credits()

func _on_Credits_menu_option_selected(option):
	option = option.to_lower()
	if option.begins_with("back"):
		back_to_menu()
