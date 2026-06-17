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
		g.next_spawn_position = spawn_position
		
		get_tree().change_scene(target_scene)
	pass # Replace with function body.
