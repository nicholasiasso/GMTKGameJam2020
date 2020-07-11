extends Camera2D

onready var tween: Tween = $Tween

func _on_Character_active_checkpoint_changed(checkpoint: Checkpoint):
	tween.interpolate_property(self, "global_position",
		global_position, checkpoint.camera_position, 1,
		Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	tween.start()
