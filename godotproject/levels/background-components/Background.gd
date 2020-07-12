extends MarginContainer

export var initial_dust_count: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
#	for i in range(initial_dust_count):
#		add_random_dust(rand_range(0, ProjectSettings.get_setting("display/window/size/width")))
		
	pass # Replace with function body.

func add_random_dust(position: Vector2) -> void:
	var dust = load("res://levels/background-components/Dust.tscn").instance()
	add_child(dust)
	dust.position = position

func _on_DustSpawnPath_add_dust(position):
	position += $DustSpawnPath.position
	add_random_dust(position)

func move_spawner(position):
	$DustSpawnPath.position += position
