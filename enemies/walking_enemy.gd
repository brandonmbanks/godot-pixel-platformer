extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ledge_check_right: RayCast2D = $LedgeCheckRight
@onready var ledge_check_left: RayCast2D = $LedgeCheckLeft

var direction = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	var found_wall = is_on_wall()
	# if the ray cast stops colliding with the ground then we have found a ledge
	var found_ledge = !ledge_check_right.is_colliding() || !ledge_check_left.is_colliding()

	if found_wall or found_ledge:
		direction *= -1
	
	animated_sprite_2d.flip_h = direction.x > 0

	velocity = direction * 25
	move_and_slide()
