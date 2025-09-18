extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const FALL_VELOCITY = 250
var wallStick := false
var leftRight
var wallTimer := 0.5
var wallTimerStart := false
var canWallStick := true


func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("ui_left", "ui_right")
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_accept") and wallStick:
		velocity.y = JUMP_VELOCITY
		if leftRight:
			velocity.x = 250
		else:
			velocity.x = -250
		wallStick = false
		wallTimerStart = true
		
	if wallTimer > 0 and wallTimerStart:
		wallTimer -= delta
		canWallStick = false
	elif wallTimerStart:
		canWallStick = true
		wallTimerStart = false
		wallTimer = 0.5
		
	if not is_on_floor() and velocity.y != 0:
		$Sprite2D.texture = preload("res://Assets/CharacterJump.tres")
		
	if is_on_floor() and velocity.x == 0:
		$Sprite2D.texture = preload("res://Assets/CharacterIdle.tres")
	
	if Input.is_action_just_pressed("ui_down"):
		velocity.y = FALL_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction and not wallStick:
		velocity.x = direction * SPEED
	elif not wallStick and canWallStick:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x != 0 and is_on_floor():
		$Sprite2D.texture = preload("res://Assets/CharacterMove.tres")
		
	if velocity.x < 0: # Moving left
		$Sprite2D.flip_h = false
		leftRight = true
	elif velocity.x > 0: # Moving right
		$Sprite2D.flip_h = true
		leftRight = false
		
	if is_on_wall() and not is_on_floor() and not Input.is_action_just_pressed("ui_accept") and canWallStick:
		wallStick = true
		velocity.y = 0
		$Sprite2D.texture = preload("res://Assets/CharacterClimb.tres")
		
	

	move_and_slide()
