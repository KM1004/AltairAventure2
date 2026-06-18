#wood
extends Area2D

var wood_taken = false

onready var globals = get_node("/root/Globals")

func _on_Wood_body_entered(body):
	if body.name == "Player" and !wood_taken:
		wood_taken = true
		$SFXPickup.play()
		globals.add_wood(1)
		queue_free()
