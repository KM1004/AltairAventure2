extends Control

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
#	global_vars.next_scene = "res://Level1.tscn"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Quit_pressed():
	global_vars.reset_globals()
	get_tree().change_scene("res://MainMenu.tscn")
	pass # Replace with function body.


func _on_Restart_pressed():
	print("RESTART CLICKED")
	global_vars.reset_globals()
	yield(get_tree(), "idle_frame")
	get_tree().change_scene(global_vars.next_scene)
	print("Health after reset:", global_vars.Health)
	pass # Replace with function body.
