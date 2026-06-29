extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Apply buoyancy when in water (water level is 0.0)
	var water_level := 0.0
	var depth := water_level - global_position.y
	if depth > -1.0: # Player is at least partially in water (capsule bottom is at y - 1.0)
		var submersion := clampf((depth + 1.0) / 2.0, 0.0, 1.0)
		var buoyancy_force := get_gravity().length() * 1.5 * submersion
		velocity.y += buoyancy_force * delta
		
		# Swim controls: Space to swim up, Shift to swim down
		var swim_speed := 3.0
		if Input.is_key_pressed(KEY_SPACE):
			velocity.y = move_toward(velocity.y, swim_speed, 15.0 * delta)
		elif Input.is_key_pressed(KEY_SHIFT):
			velocity.y = move_toward(velocity.y, -swim_speed, 15.0 * delta)
		else:
			# Apply water drag to prevent infinite bobbing/oscillations
			velocity.y = move_toward(velocity.y, 0.0, 4.0 * delta)

	move_and_slide()
