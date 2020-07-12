extends MarginContainer

export var initial_dust_count: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(initial_dust_count):
		add_random_dust(rand_range(0, ProjectSettings.get_setting("display/window/size/width")))
		
	pass # Replace with function body.

func add_random_dust(x_offset: int =0) -> void:
	$DustSpawnPath/DustSpawner.offset = randi()
	var dust = load("res://levels/background-components/Dust.tscn").instance()
	add_child(dust)
	dust.position = $DustSpawnPath/DustSpawner.position
	dust.position = Vector2(dust.position.x - x_offset, dust.position.y)


func _on_DustTimer_timeout():
	add_random_dust()
