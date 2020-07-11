extends RigidBody2D

export(float) var ROTATION_SPEED: float = 5.0
export(float) var ROTATION_ACCEL: float = 200.0
export(float) var THRUST_FORCE: float = 200.0

func _ready():
	pass

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var thrust: Vector2 = Vector2(0, -THRUST_FORCE).rotated(rotation)
	set_applied_force(thrust * Input.get_action_strength("up"))


	var rotation_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	var target_angular_velocity: float = rotation_direction * ROTATION_SPEED
	var torque = (target_angular_velocity - angular_velocity) * ROTATION_ACCEL
	set_applied_torque(torque)
