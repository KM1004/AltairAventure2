#extends Area2D
#
#
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#
#func _on_boat_input_event(viewport, event, shape_idx):
#	if event.is_action_pressed("ui_accept"):  # use mouse click
#		get_node("/root/Globals").portal_from_scene = get_tree().current_scene.filename
#		get_tree().change_scene("res://PortalMenu.tscn")
#	pass # Replace with function body.

extends Node2D

var player_in_range = false

func _ready():
	$Panel.visible = false   # "Press E" UI


func _process(delta):
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		open_portal()


func open_portal():
	var globals = get_node("/root/Globals")

	# Save current scene (for return if needed)
	globals.portal_from_scene = get_tree().current_scene.filename

	# Go to portal menu
	get_tree().change_scene("res://BoatPortal.tscn")


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		$Panel.visible = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		$Panel.visible = false


func _on_boat_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		$Panel.visible = true
	pass # Replace with function body.


func _on_boat_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		$Panel.visible = false
	pass # Replace with function body.
