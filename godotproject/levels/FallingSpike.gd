extends Sprite
class_name FallingSpike

onready var timer: Timer = $Timer

var is_falling = false
const GRAVITY_VECTOR: Vector2 = Vector2(0, 200)
var velocity: Vector2 = Vector2.ZERO

var character: Character

func fall(character_: Character):
	is_falling = true
	character = character_
	timer.start()
	
func _process(delta: float) -> void:
	if is_falling:
		velocity += GRAVITY_VECTOR * delta
		global_position += velocity * delta
		
	if timer.time_left < 0.5:
		is_falling = false
		if !!character:
			character.drop_antennae()
			character = null
		
	if timer.time_left < 0.4:
		visible = false
	if timer.time_left < 0.3:
		visible = true
	if timer.time_left < 0.2:
		visible = false
	if timer.time_left < 0.1:
		visible = true
	


func _on_Timer_timeout():
	queue_free()
