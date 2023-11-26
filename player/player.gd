extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var GRAVITY: int = 5
@export var ACCELERATION: int = 10
@export var FRICTION: int = 10
@export var MAX_SPEED: int = 75
@export var JUMP_FORCE: int = -140
@export var JUMP_RELEASE_FORCE: int = -70

func _physics_process(delta: float) -> void:
	apply_gravity()
	
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	
	if input.x > 0:
		animated_sprite_2d.flip_h = true
	elif input.x < 0:
		animated_sprite_2d.flip_h = false

	if input.x == 0:
		apply_friction()
	else:
		apply_acceleration(input.x)

	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = JUMP_FORCE
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
		
		if velocity.y > 0:
			velocity.y += GRAVITY * 1.5

	move_and_slide()

func apply_gravity():
	velocity.y += GRAVITY

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(input_x: float):
	velocity.x = move_toward(velocity.x, MAX_SPEED * input_x, ACCELERATION)
