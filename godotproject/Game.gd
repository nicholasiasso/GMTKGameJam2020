extends Node2D

func _ready() -> void:
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	$MainMenu.connect("menu_option_selected", self, "start_game")

func start_game() -> void:
	var world = load("res://levels/World.tscn").instance()
	$MainMenu.visible = false
	$MainMenu.queue_free()
	self.add_child(world)
