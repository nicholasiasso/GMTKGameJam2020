extends Area2D
class_name Checkpoint

onready var hover_animation_player: AnimationPlayer = $HoverAnimationPlayer
onready var glow_animation_player: AnimationPlayer = $ActivatedGlow/GlowAnimationPlayer
onready var activated_glow: Sprite = $ActivatedGlow
onready var sprite: Sprite = $Sprite

onready var camera_center: Node2D = $CameraCenter
var camera_position: Vector2

var is_active = false setget set_is_active

func _ready() -> void:
	hover_animation_player.play("Float")
	glow_animation_player.play("Glow")
	activated_glow.visible = false
	camera_position = camera_center.global_position
	
	
func set_is_active(active: bool) -> void:
	if active:
		sprite.visible = false
		activated_glow.visible = active
		is_active = active
	else:
		queue_free()

func get_spawn_position() -> Vector2:
	return global_position + Vector2.UP * 6
