extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func go_to_scene(scene_path, spawn_pos):
	var g = get_node("/root/Globals")
	
	g.next_scene = scene_path
	g.next_spawn_position = spawn_pos
	
	get_tree().change_scene(scene_path)


func _on_Level1_pressed():
	go_to_scene("res://Beach.tscn", Vector2(1344, 736))
	pass # Replace with function body.


func _on_Level2_pressed():
	go_to_scene("res://SnowBeach.tscn", Vector2(896, 544))
	pass # Replace with function body.


func _on_Level3_pressed():
	go_to_scene("res://LevelScenes/Level 3.tscn", Vector2(-672, -384))
	pass # Replace with function body.


func _on_Level4_pressed():
	go_to_scene("res://LevelScenes/Level 4.tscn", Vector2(32, -64))
	pass # Replace with function body.
