extends KinematicBody2D
class_name Enemy

var player = null
#var player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_Player_detector_body_entered(body):
#	if body is Player:
#		if player == null:
#			player = body
			print("found the player")
	


func _on_Player_detector_body_exited(body):
	pass # Replace with function body.
