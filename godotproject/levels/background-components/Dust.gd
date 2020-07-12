extends Node2D

export var min_speed: int = 25
export var max_speed: int = 50

export var min_scale: int = 4
export var max_scale: int = 16

# Random speed set when created
var speed: int = rand_range(min_speed, max_speed)

func _ready():
	#Random scale for sprite when created 
	scale = Vector2(rand_range(min_scale, max_scale), 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x = self.position.x - (speed * delta)
