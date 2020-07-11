extends Area2D

onready var animation_player: AnimationPlayer = $AnimationPlayer

class_name Checkpoint

func _ready():
	animation_player.play("Float")
