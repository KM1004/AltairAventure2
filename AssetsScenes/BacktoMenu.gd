extends Button


var skip_to_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# This is a custom method called by StoryBox parent
func _loadSkipToScene(scene):
	skip_to_scene = scene
	pass

func _pressed():
	get_tree().change_scene(skip_to_scene)
	pass
