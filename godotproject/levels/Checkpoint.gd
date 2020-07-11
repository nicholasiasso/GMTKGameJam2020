extends Area2D

onready var hover_animation_player: AnimationPlayer = $HoverAnimationPlayer
onready var glow_animation_player: AnimationPlayer = $ActivatedGlow/GlowAnimationPlayer
onready var activated_glow: Sprite = $ActivatedGlow

class_name Checkpoint

var is_active = false setget set_is_active

func _ready():
	hover_animation_player.play("Float")
	glow_animation_player.play("Glow")
	activated_glow.visible = false
	
	
func set_is_active(active: bool):
	is_active = active
	activated_glow.visible = active
