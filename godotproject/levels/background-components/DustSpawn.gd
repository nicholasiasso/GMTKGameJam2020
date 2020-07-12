extends Path2D

signal add_dust(position)

func _on_DustTimer_timeout():
	$DustSpawnLocation.offset = randi()
	emit_signal("add_dust", $DustSpawnLocation.position)
