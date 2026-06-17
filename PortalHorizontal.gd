extends Area2D

export(String) var target_scene
export(Vector2) var spawn_position

var used = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PortalHorizontal_body_entered(body):
	if used:
		return
		
	if body.name == "Player":
		used = true
		
		var g = get_node("/root/Globals")
		
		g.next_scene = target_scene
		g.next_spawn_position = spawn_position
		
		if target_scene == "res://SnowBeach.tscn" or target_scene == "res://SnowyForest.tscn" or target_scene == "res://FrozenLake.tscn":
			g.loading_text = "A frozen land where icy winds and hidden dangers await beneath the ice."
			
		elif target_scene == "res://Beach.tscn"or target_scene == "res://Forest.tscn" or target_scene == "res://Forest2.tscn":
			g.loading_text = "A peaceful island filled with lush trees and wandering creatures."
		
		elif target_scene == "res://LevelScenes/Level 3.tscn":
			g.loading_text = "A magical forest glowing with mystery and ancient power."
		
		elif target_scene == "res://LevelScenes/Level 4.tscn":
			g.loading_text = "A land of fire and ashes, where survival is never certain."
		
		get_tree().change_scene("res://Loading.tscn")
	pass # Replace with function body.
