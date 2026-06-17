#LEVEL 3
extends Node2D

onready var player = $Player
onready var water = $water
onready var water_timer = $WaterTimer
onready var ladders = $ladders

const REQUIRED_WOOD = 10

onready var globals = get_node("/root/Globals")



var player_in_water = false

var wood = 0
var wood_needed = 10
var ladder_cells = []


	
func _ready():
	$ladders.visible = false
	
	if !globals.is_connected("wood_changed", self, "_on_wood_changed"):
		globals.connect("wood_changed", self, "_on_wood_changed")
		
	_on_wood_changed(globals.Wood)
		

func _on_wood_changed(amount):
	if amount >= REQUIRED_WOOD:
		build_ladder()

 
func build_ladder():
	print("building ladder")
	ladders.visible = true


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
		globals.Health -= 5
		
		




