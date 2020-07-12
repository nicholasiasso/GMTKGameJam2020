extends Node2D

var is_menu: bool = false

func _ready() -> void:
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)

func start_game() -> void:
	$MainMenu.visible = false
	$MainMenu.queue_free()
	is_menu = false
	$StartTimer.start()
	$GmtkLogo.visible = true
	$GmtkLogo.playing = true

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
	var curr_player: AudioStreamPlayer = get_curr_audio_stream_player()
	if value == 0:
		curr_player.stream_paused = true
	else:
		curr_player.stream_paused = false
		#Default dbs is -12
		var dbs: int = -12
		if value < 7:
			dbs -= (7-value) * 2
		elif value > 7:
			dbs += (value-7) * 2
		curr_player.volume_db = dbs
		
func get_curr_audio_stream_player():
	if is_menu:
		return $MainMenuPlayer
	else:
		return $LevelPlayer


func _on_StartTimer_timeout():
	$GmtkLogo.visible = false
	var world = load("res://levels/World.tscn").instance()
	self.add_child(world)
	var camera: Node = get_tree().get_nodes_in_group("CameraGroup")[0]
	camera.connect("camera_moved", $Background, "move_spawner")
	$MainMenuPlayer.stop()
	$LevelPlayer.play()
	
