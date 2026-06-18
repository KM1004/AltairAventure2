extends Panel



# Show properties on editor
export (String, FILE, "*.txt") var skip_to_scene
export (String, FILE, "*.txt") var story_line_file
export (SpriteFrames) var person

# Changeable properties during runtime
onready var stsNode = get_node("SkipToScene") # to skip to next world
onready var cbNode = get_node("ChatBox") # to add our story
onready var pNode = get_node("Person") # to add a person sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Loading file:", story_line_file)
#	stsNode._loadSkipToScene(skip_to_scene)
	cbNode._loadDialogFromFile(story_line_file)
	pNode.frames = person
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


