extends Area2D

signal wood_colected

var wood_taken = false

func _on_Wood_body_entered(body):
	if body.name == "Player":
		wood_taken = true
		
		emit_signal("wood_signal")
		#get_node("/root/MainHud").wood += 1
		queue_free()
