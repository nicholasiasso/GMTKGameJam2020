extends RigidBody2D

export(float) var ROTATION_SPEED: float = 5.0
export(float) var ROTATION_ACCEL: float = 200.0
export(float) var THRUST_FORCE: float = 200.0

export(float) var INPUT_DELAY_MSECS: int = 1000

var input_slices: Array = []
var active_checkpoint: Checkpoint
var colliding_checkpoint: Checkpoint

class InputSlice:
	# I'm not using getters and setters here because
	# this class is meant to emulate a struct
	var up_action_strength: float
	var left_action_strength: float
	var right_action_strength: float
	var game_tick_msec: int
	
func _process(_delta: float) -> void:
	save_current_input()
	if !!colliding_checkpoint:
		if abs(rotation) < 0.1 and linear_velocity.length_squared() <= 0.1:
			if !!active_checkpoint:
				active_checkpoint.is_active = false
			active_checkpoint = colliding_checkpoint
			active_checkpoint.is_active = true

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if Input.is_action_just_pressed("reset"):
		state.transform = Transform2D(0.0, active_checkpoint.global_position)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		input_slices = []
		return
		
	var current_input: InputSlice = pop_and_return_delayed_input()
	if !current_input:
		return
		
	var applied_thrust: Vector2 = Vector2(0, -THRUST_FORCE).rotated(rotation) * current_input.up_action_strength
	
	set_applied_force(applied_thrust)
	#Set whether fire particle should be emitting
	var fire_particle = $FireParticle
	fire_particle.emitting = applied_thrust != Vector2.ZERO
	fire_particle.angle = -self.rotation_degrees

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

func _on_CheckpointCollider_area_entered(area: Checkpoint):
	if !area:
		return
	colliding_checkpoint = area

func _on_CheckpointCollider_area_exited(area: Checkpoint):
	if !area:
		return
	colliding_checkpoint = null
