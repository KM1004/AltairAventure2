extends Area2D




func _on_Artifact3_body_entered(body):
	if body.name == "Player":
		get_node("/root/Globals").collect_artifact(2)
		queue_free()
	pass # Replace with function body.
