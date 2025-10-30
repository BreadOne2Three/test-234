extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const FALL_VELOCITY = 300
var canWallClimb :bool= true
var wallClimbing :bool= false



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if not is_on_floor() and velocity.y != 0:
		$Sprite2D.texture = preload("res://Assets/Jump.tres");
		
	if is_on_floor() and velocity.x == 0:
		$Sprite2D.texture = preload("res://Assets/Idle.tres");
		
	if is_on_floor() and velocity.x != 0:
		$Sprite2D.texture = preload("res://Assets/Move.tres");
		
	if Input.is_action_just_pressed("ui_down"):
		velocity.y = FALL_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and not wallClimbing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
		
	if is_on_wall() and not is_on_floor() and canWallClimb:
		wallClimbing = true
		velocity.y = 0
		$Sprite2D.texture = preload("res://Assets/Climb.tres");
		

	move_and_slide()
