extends Node2D

var player_in_range = false

func _ready():
	$Panel.visible = false   # "Press E"w

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		open_shop()

func open_shop():
	var globals = get_node("/root/Globals")

	# SAVE where player came from
	globals.next_scene = get_tree().current_scene.filename

	# GO TO SHOP
	get_tree().change_scene("res://Shop.tscn")

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		$Panel.visible = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		$Panel.visible = false
