extends Area2D

onready var global_vars = get_node("/root/Globals")


var player_inside = false
var damage_timer = 0.0
var damage_interval = 1.0


func _process(delta):
	if player_inside:
		damage_timer += delta
		
		if damage_timer >= damage_interval:
			damage_timer = 0
			global_vars.Health -= 1


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player_inside = true
		#SFX LAVA
		damage_timer =0.0
	elif body.is_in_group("enemy"):
		body.queue_free()
	

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player_inside = false
	
	
		
