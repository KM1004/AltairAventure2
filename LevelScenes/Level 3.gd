extends Node2D

onready var player = $Player
onready var water = $water
onready var water_timer = $WaterTimer

var player_in_water = false

func _process(delta):
	var cell = water.world_to_map(player.global_position)
	# Returns -1 if there is no tile
	var on_water = water.get_cellv(cell) != -1

	if on_water and !player_in_water:
		player_in_water = true
		water_timer.start()

	elif !on_water and player_in_water:
		player_in_water = false
		water_timer.stop()
		

func _on_WaterTimer_timeout():
	if player_in_water:
		player.lives -= 1
		#print("Took water damage! Lives:", player.lives)
