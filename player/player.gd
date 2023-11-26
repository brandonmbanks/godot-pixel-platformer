extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var GRAVITY: int = 5
@export var ACCELERATION: int = 10
@export var FRICTION: int = 10
@export var MAX_SPEED: int = 75
@export var JUMP_FORCE: int = -140
@export var JUMP_RELEASE_FORCE: int = -70
@export var NUM_JUMPS: int = 2
@export var SPRITE: SpriteFrames = load("res://player/player_green.tres")
@export var CONTROLS: PlayerControls = load("res://player/p1_controls.tres")

var jumps_remaining: int = NUM_JUMPS

func _ready() -> void:
	animated_sprite_2d.sprite_frames = SPRITE

func _physics_process(_delta: float) -> void:
	# constantly apply gravity
	apply_gravity()
	
	var input = Vector2.ZERO
	input.x = Input.get_axis(CONTROLS.move_left, CONTROLS.move_right)

	# movement
	if input.x == 0:
		apply_friction()
	else:
		apply_acceleration(input.x)

	# jump
	if Input.is_action_just_pressed(CONTROLS.jump) and jumps_remaining > 1:
		velocity.y = JUMP_FORCE
		jumps_remaining -= 1

	if is_on_floor():
		jumps_remaining = NUM_JUMPS
	else:
		animated_sprite_2d.play("jump")
		if Input.is_action_just_released(CONTROLS.jump) and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
		
		if velocity.y > 0:
			velocity.y += GRAVITY * 1.5

	var was_in_air = not is_on_floor()
	move_and_slide()
	var just_landed = is_on_floor() and was_in_air
	# if we just landed we want to set the animation to te 2nd frame of run
	if just_landed:
		animated_sprite_2d.play("run")
		animated_sprite_2d.set_frame(1)

func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 300)

func apply_friction():
	animated_sprite_2d.play("idle")
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(input_x: float):
	# flip sprite direction
	if input_x > 0:
		animated_sprite_2d.flip_h = true
	elif input_x < 0:
		animated_sprite_2d.flip_h = false

	animated_sprite_2d.play("run")
	velocity.x = move_toward(velocity.x, MAX_SPEED * input_x, ACCELERATION)
