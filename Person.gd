extends Area2D

onready var sbNode = get_node("StoryBox")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			$StoryBox.visible = true
	pass


func _on_Person_body_exited(body):
		if body.name == "Player":
			$StoryBox.visible = false
		pass # Replace with function body.
