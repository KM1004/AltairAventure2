extends "res://EnemiesScenes/Orc1.gd"




func _on_DetectRange_body_entered(body):
	if body.name == "Player":
		player = body
		player_in_range = true


func _on_DetectRange_body_exited(body):
	if body == player:
		player_in_range = false
		player = null
		state = IDLE


func _on_AttackArea_body_entered(body):
	if body == player:
		player_in_attack_range = true


func _on_AttackArea_body_exited(body):
	if body == player:
		player_in_attack_range = false


func _on_TakeDamage_body_entered(body):
	if body.is_in_group("player_weapon"):
		energy -= 3

		if energy <= 0:
			die()
		else:
			state = HURT
