extends CharacterBody2D

@export var speed: float = 500.0
@export var acceleration: float = 1500.0
@export var deceleration: float = 1000.0
@export var jump_height: float = 120.0
@export var time_to_jump_apex: float = 0.4
@export var fall_multiplier: float = 2.7
@export var low_jump_multiplier: float = 1.0
@export var glide_fall_multiplier: float = 0.5
@export var adjusted_glide_fall_multiplier: float = 0.2 # Reduced glide fall during roll
@export var boosted_speed: float = 500.0  # Speed during boost
@export var speed_boost_duration: float = 2.0

@onready var trail_2d = $flip/Trail2D
@onready var runparticles = $flip/runparticles
@onready var rollparticles = $flip/rollparticles
@onready var speed_boost_timer = $SpeedBoostTimer
@onready var run_idle = $run_idle
@onready var ducking = $ducking
@onready var rollshape = $rollshape
@onready var animations = $flip/animations
@onready var animation_player = $AnimationPlayer
@onready var flip = $flip
@onready var flightsound = $flip/flightsound
@onready var flightsound_2 = $flip/flightsound2
@onready var walk = $flip/walk
@onready var roll_sound = $flip/rollSound

# Constants for calculations
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_velocity = -2 * jump_height / time_to_jump_apex
var direction = 0.0
var is_rolling = false
var is_gliding = false
var jump_count = 0
var can_roll: bool = true
var roll_cooldown: float = 1.5
var roll_timer: float = 0.0

func _ready():
	# Ensure the correct initial collision box is active
	_set_collision_shape("idle")
	# Configure the speed boost timer
	speed_boost_timer.one_shot = true
	speed_boost_timer.wait_time = speed_boost_duration
	runparticles.emitting = false
	rollparticles.emitting = false
	trail_2d.visible = true

func _physics_process(delta):
	# Handle gravity
	if not is_on_floor():
		animation_player.play("trail1")
		if Input.is_action_pressed("jumpUp") and not is_on_floor() and velocity.y > 0 and not is_rolling:
			# Start gliding if the player is holding the jump button while falling
			animations.play("glide")
			is_gliding = true
			velocity.y += gravity * glide_fall_multiplier * delta
			_stop_all_particles()
		else:
			# Apply different multipliers based on the character's jump state
			if velocity.y > 0:
				velocity.y += gravity * fall_multiplier * delta
			elif velocity.y < 0 and not Input.is_action_pressed("jumpUp"):
				velocity.y += gravity * low_jump_multiplier * delta
			else:
				velocity.y += gravity * delta
	else:
		animation_player.play_backwards("trail1")
		is_gliding = false

		# Reset speed to normal when touching the floor
		speed = 300.0

		# Reset jump count only if roll animation has finished
		if not animation_player.is_playing() or animation_player.current_animation != "roll":
			jump_count = 0  # Reset jump count when grounded and not rolling
		velocity.y += gravity * delta

	# Handle movement and input only if not rolling
	if not is_rolling:
		_handle_input(delta)
	else:
		# Keep rolling until the animation finishes
		if animation_player.is_playing() and animation_player.current_animation == "roll":
			rollparticles.emitting = true
			roll_sound.play()
			runparticles.emitting = false
		else:
			is_rolling = false  # Exit rolling state once the animation ends
			glide_fall_multiplier = 0.5 # Restore original glide multiplier after roll
			_stop_all_particles()

	# Handle roll cooldown timer
	if not can_roll:
		roll_timer += delta
		if roll_timer >= roll_cooldown:
			can_roll = true
			roll_timer = 0.0

	move_and_slide()

func _handle_input(delta):
	# Handle jump and double jump
	if Input.is_action_just_pressed("jumpUp") and (is_on_floor() or jump_count < 2):
		velocity.y = jump_velocity
		jump_count += 1  # Increment jump count
		
		if jump_count == 1:
			flightsound_2.play()
			animations.play("glide")
		# Play glide animation if it's the second jump and apply speed boost
		if jump_count == 2:
			animations.play("glide")
			flightsound.play()
			is_gliding = true
			_apply_speed_boost()
		else:
			is_gliding = false  # Reset gliding when jumping
			_stop_all_particles()

	# Handle movement
	direction = Input.get_axis("go_left", "go_right")

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		
		# Only play the running animation if on the ground and not gliding
		if is_on_floor() and not is_gliding:
			if Input.is_action_pressed("duck"):
				_set_collision_shape("ducking")
				animations.play("duckrun")
				_stop_all_particles()
			else:
				_set_collision_shape("idle")
				animations.play("run")
				rollparticles.emitting = false
				runparticles.emitting = true
		
		# Handle flip for direction
		if direction > 0:
			flip.scale.x = 1
		elif direction < 0:
			flip.scale.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		_stop_all_particles()
		
		if is_on_floor() and not is_gliding:
			if Input.is_action_pressed("duck"):
				_set_collision_shape("ducking")
				animations.play("duckidle")
			else:
				_set_collision_shape("idle")
				animations.play("idle")
				_stop_all_particles()
				
	# Roll can now happen whether on the ground or in the air, including while gliding
	if Input.is_action_just_pressed("roll") and can_roll:
		is_rolling = true
		_set_collision_shape("roller")
		animations.play("roll")
		rollparticles.emitting = true
		runparticles.emitting = false
		is_gliding = false
		
		# Reset jumps if rolling in the air and start cooldown
		if not is_on_floor():
			jump_count = 0
			can_roll = false  # Disable rolling until cooldown is over
			glide_fall_multiplier = adjusted_glide_fall_multiplier # Decrease glide multiplier during roll
			
func _apply_speed_boost():
	# Temporarily boost speed for the second jump
	speed = boosted_speed
	speed_boost_timer.start()

func _set_collision_shape(state: String) -> void:
	# Disable all collision shapes
	run_idle.disabled = true
	ducking.disabled = true
	rollshape.disabled = true

	# Enable the correct collision shape based on the state
	match state:
		"idle", "run":
			run_idle.disabled = false
		"ducking":
			ducking.disabled = false
		"roller":
			rollshape.disabled = false

func _on_speed_boost_timer_timeout():
	speed = 300.0

func _stop_all_particles():
	# Helper function to stop all particles
	runparticles.emitting = false
	rollparticles.emitting = false
