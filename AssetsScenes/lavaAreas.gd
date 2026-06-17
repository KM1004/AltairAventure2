extends Area2D


var player = null

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		print("body in lava")
	
	
		
