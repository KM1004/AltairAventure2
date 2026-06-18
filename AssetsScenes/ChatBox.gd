extends Label



var drawTextSpeed: int = 0
var chatterLimit: int = 70 # max characters in chatbox
var dialog = [] # list of story lines
var current_file =""
var page = 0

func _loadDialogFromFile(fname):
	current_file = fname
	
	dialog.clear()
	page = 0
	drawTextSpeed = 0

	var f = File.new()
	f.open(fname, File.READ)

	while not f.eof_reached():
		dialog.append(f.get_line())

	f.close()

	if dialog.size() > 0:
		set_text(dialog[0])

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Print story line by line
func _showChatter():
	if drawTextSpeed < chatterLimit: # print 1 char at a time
		drawTextSpeed += 1
		self.visible_characters = drawTextSpeed
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_showChatter()
	pass


func _on_SkipStoryLines_pressed():
	if page < dialog.size()-1:
		page += 1
		set_text(dialog[page])
	else:
		page = 0
		set_text(dialog[page])
	
	# reset chatter box method to show new chat line
	drawTextSpeed = 0
	_showChatter()
	pass # Replace with function body.


func _on_SkipToScene_pressed():
	if get_parent().skip_to_scene != "":
		_loadDialogFromFile(get_parent().skip_to_scene)
	
