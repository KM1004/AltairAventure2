extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 400
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
#func _ready():
#	if direction == Vector2.RIGHT:
#		rotation = 0
#	elif direction == Vector2.LEFT:
#		rotation = deg2rad(180)
#	elif direction == Vector2.DOWN:
#		rotation = deg2rad(90)
#	elif direction == Vector2.UP:
#		rotation = deg2rad(-90)
#	pass # Replace with function body.


func set_direction(dir):
	direction = dir.normalized()
	rotation = direction.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction * speed * delta

func _on_Arrow_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(3)

	queue_free()
	pass # Replace with function body.
