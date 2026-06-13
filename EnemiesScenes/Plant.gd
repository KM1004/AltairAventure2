extends KinematicBody2D

#const UP = Vector2(0, -1)
const SPEED = 200
#const GRAVITY = 20
#const JUMP_HEIGHT = -600

var motion = Vector2()

func _physics_process(delta):

	# Reset movement every frame
	motion = Vector2()

	# RIGHT
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.flip_h = false
		motion.x += SPEED

	# LEFT
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite.flip_h = true
		motion.x -= SPEED

	# DOWN
	if Input.is_action_pressed("ui_down"):
		motion.y += SPEED

	# UP
	if Input.is_action_pressed("ui_up"):
		motion.y -= SPEED

	# Idle animation
	if motion == Vector2():
		$AnimatedSprite.play("d_idle")

	# Normalize diagonal movement
	motion = motion.normalized() * SPEED

	# Move player
	motion = move_and_slide(motion)
