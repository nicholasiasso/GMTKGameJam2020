extends Area2D

onready var hover_animation_player: AnimationPlayer = $HoverAnimationPlayer
onready var glow_animation_player: AnimationPlayer = $ActivatedGlow/GlowAnimationPlayer
onready var activated_glow: Sprite = $ActivatedGlow

onready var camera_center: Node2D = $CameraCenter
var camera_position: Vector2

class_name Checkpoint

var is_active = false setget set_is_active

func _ready() -> void:
	hover_animation_player.play("Float")
	glow_animation_player.play("Glow")
	activated_glow.visible = false
	camera_position = camera_center.global_position
	
	
func set_is_active(active: bool) -> void:
	is_active = active
	activated_glow.visible = active

func get_spawn_position() -> Vector2:
	return global_position + Vector2.UP * 6
