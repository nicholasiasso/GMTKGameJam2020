extends Node2D

onready var character: Character = $Character
onready var falling_spike: FallingSpike = $FallingSpike

func _on_Checkpoint13_checkpoint_activated():
	falling_spike.fall(character)
	character.pause_for_cutscene()
