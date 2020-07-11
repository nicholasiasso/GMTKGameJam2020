extends RigidBody2D

export(float) var ROTATION_SPEED: float = 5.0
export(float) var ROTATION_ACCEL: float = 200.0
export(float) var THRUST_FORCE: float = 200.0

export(float) var INPUT_DELAY_MSECS: int = 1000

var input_slices: Array = []

class InputSlice:
	# I'm not using getters and setters here because
	# this class is meant to emulate a struct
	var up_action_strength: float
	var left_action_strength: float
	var right_action_strength: float
	var game_tick_msec: int
	
func _process(_delta: float) -> void:
	save_current_input()

func _integrate_forces(_state: Physics2DDirectBodyState) -> void:

	var current_input: InputSlice = pop_and_return_delayed_input()
	if !current_input:
		return
		
	var thrust: Vector2 = Vector2(0, -THRUST_FORCE).rotated(rotation)
	set_applied_force(thrust * current_input.up_action_strength)

	var rotation_direction = current_input.right_action_strength - current_input.left_action_strength
	var target_angular_velocity: float = rotation_direction * ROTATION_SPEED
	var torque = (target_angular_velocity - angular_velocity) * ROTATION_ACCEL
	set_applied_torque(torque)
	
func save_current_input() -> void:
	var current_input: InputSlice = InputSlice.new()
	current_input.up_action_strength = Input.get_action_strength("up")
	current_input.left_action_strength = Input.get_action_strength("left")
	current_input.right_action_strength = Input.get_action_strength("right")
	current_input.game_tick_msec = OS.get_ticks_msec()
	input_slices.push_back(current_input)

func pop_and_return_delayed_input() -> InputSlice:
	var current_game_tick_msec = OS.get_ticks_msec()
	var result: InputSlice
	while input_slices.size() != 0 and input_slices.front().game_tick_msec + INPUT_DELAY_MSECS < current_game_tick_msec:
		result = input_slices.pop_front()
	return result
