#extends KinematicBody2D
#
#
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#extends KinematicBody2D
#
#export var speed = 200
#var velocity = Vector2.ZERO
#
#func _physics_process(delta):
#	var input_vector = Vector2.ZERO
#
#	# Get input strength for 4 directions
#	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	input_vector.y = Input.get_action_strength("ui_bottom") - Input.get_action_strength("ui_up")
#
#	# Normalize to prevent fast diagonal movement
#	input_vector = input_vector.normalized()
#
#	if input_vector != Vector2.ZERO:
#		velocity = input_vector * speed
#	else:
#		velocity = Vector2.ZERO
#
#	# Apply movement and handle collisions
#	velocity = move_and_slide(velocity)

extends KinematicBody2D

export var speed = 200
var velocity = Vector2.ZERO

func _ready():
	# Camera limits (optional)
	var map = get_parent().get_node("TileMap")
	var map_limits = map.get_used_rect()
	var map_cellsize = map.cell_size
	var cam = $Camera2D
	cam.limit_left = map_limits.position.x * map_cellsize.x
	cam.limit_top = map_limits.position.y * map_cellsize.y
	cam.limit_right = map_limits.end.x * map_cellsize.x
	cam.limit_bottom = map_limits.end.y * map_cellsize.y

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	# Get input strength for 4 directions
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Normalize to prevent fast diagonal movement
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO

	# Apply movement and handle collisions
	velocity = move_and_slide(velocity)
