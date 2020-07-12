extends RigidBody2D
class_name Character

export(float) var ROTATION_SPEED: float = 5.0
export(float) var ROTATION_ACCEL: float = 200.0
export(float) var THRUST_FORCE: float = 200.0

export(float) var INPUT_DELAY_MSECS: int = 1000

var has_antennae: bool = true
export(float) var ANTENNAE_ROTATION_DEG: float = 15
onready var antennae: Node2D = $Antennae
const AntennaeFalling: Resource = preload("res://character/AntennaeFalling.tscn")
onready var cutscene_timer: Timer = $CutsceneTimer
var is_paused: bool = false
const CommsWarning: Resource = preload("res://character/CommsWarning.tscn")

var input_slices: Array = []
var active_checkpoint: Checkpoint
var colliding_checkpoint: Checkpoint
var is_on_screen: bool = true

var camera: Camera2D

signal active_checkpoint_changed(checkpoint)

class InputSlice:
	# I'm not using getters and setters here because
	# this class is meant to emulate a struct
	var up_action_strength: float
	var left_action_strength: float
	var right_action_strength: float
	var game_tick_msec: int
	
func _process(_delta: float) -> void:
	save_current_input()
	if !!colliding_checkpoint and active_checkpoint != colliding_checkpoint:
		if abs(rotation) < 0.1 and linear_velocity.length_squared() <= 0.1:
			if !!active_checkpoint:
				active_checkpoint.is_active = false
			active_checkpoint = colliding_checkpoint
			active_checkpoint.is_active = true
			emit_signal("active_checkpoint_changed", active_checkpoint)
	if has_antennae and !!antennae:
		var delta = sin(OS.get_ticks_msec() / 400.0) * 15
		antennae.rotation_degrees = -rotation_degrees + ANTENNAE_ROTATION_DEG + delta

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if Input.is_action_just_pressed("reset") || !self.is_on_screen:
		state.transform = Transform2D(0.0, active_checkpoint.get_spawn_position())
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		input_slices = []
		set_applied_force(Vector2.ZERO)
		set_applied_torque(0.0)
		self.is_on_screen = true
		colliding_checkpoint = null
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
	if is_paused:
		return
	var current_input: InputSlice = InputSlice.new()
	current_input.up_action_strength = Input.get_action_strength("up")
	current_input.left_action_strength = Input.get_action_strength("left")
	current_input.right_action_strength = Input.get_action_strength("right")
	current_input.game_tick_msec = OS.get_ticks_msec()
	input_slices.push_back(current_input)

func get_current_input_delay() -> int:
	if has_antennae:
		return 0
	return INPUT_DELAY_MSECS

func pop_and_return_delayed_input() -> InputSlice:
	var current_game_tick_msec = OS.get_ticks_msec()
	var result: InputSlice
	while input_slices.size() != 0 and input_slices.front().game_tick_msec + get_current_input_delay() < current_game_tick_msec:
		result = input_slices.pop_front()
	return result
	
func drop_antennae() -> void:
	has_antennae = false
	var antennae_falling = AntennaeFalling.instance()
	antennae_falling.global_position = antennae.global_position
	antennae.queue_free()
	get_parent().add_child(antennae_falling)
	get_parent().move_child(antennae_falling, get_parent().get_child_count() - 1)
	var comms_warning = CommsWarning.instance()
	add_child(comms_warning)
	

func _on_CheckpointCollider_area_entered(area: Checkpoint):
	if area:
		colliding_checkpoint = area

func _on_CheckpointCollider_area_exited(area: Checkpoint):
	if area:
		colliding_checkpoint = null

func _on_SpikeCollider_area_entered(area: SpikeArea2D):
	if area:
		self.is_on_screen = false

func _on_CameraCollider_area_exited(area: CameraBoundingBox):
	if area:
		self.is_on_screen = false

func pause_for_cutscene() -> void:
	is_paused = true
	cutscene_timer.start()

func _on_CutsceneTimer_timeout():
	is_paused = false
