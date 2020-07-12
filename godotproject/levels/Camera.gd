extends Camera2D

onready var tween: Tween = $Tween

signal camera_moved(position)

func _on_Character_active_checkpoint_changed(checkpoint: Checkpoint):
	emit_signal("camera_moved", checkpoint.camera_position - global_position)
	tween.interpolate_property(self, "global_position",
		global_position, checkpoint.camera_position, 1,
		Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	tween.start()
