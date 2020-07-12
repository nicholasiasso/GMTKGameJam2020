extends Sprite

onready var timer: Timer = $Timer

var velocity: Vector2 = Vector2(0, -30)
var gravity: Vector2 = Vector2(0, 30)
var spin_degs_per_sec: int = 200

func _ready() -> void:
	timer.start()

func _process(delta: float) -> void:
	velocity += gravity * delta
	global_position += velocity * delta
	rotation_degrees += spin_degs_per_sec * delta

func _on_Timer_timeout():
	queue_free()
