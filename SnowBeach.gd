extends Node2D
onready var global_vars = get_node("/root/Globals")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()

	var centered_position = (screen_size - window_size) / 2
	OS.set_window_position(centered_position)
	global_vars.next_scene = "res://SnowBeach.tscn"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
