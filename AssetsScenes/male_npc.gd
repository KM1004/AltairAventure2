extends "res://AssetsScenes/female_npc.gd"




func _on_male_npc_body_entered(body):
	if body.name == "Player":
		show_panel()
	pass # Replace with function body.


func _on_male_npc_body_exited(body):
	if body.name == "Player":
		hide_panel()
	pass # Replace with function body.
