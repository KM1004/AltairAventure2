#LEVEL 3
extends Node2D

onready var player = $Player
onready var water = $water
onready var water_timer = $WaterTimer
onready var ladder1 = $ladders
onready var ladder2 = $ladders2


onready var global_vars = get_node("/root/Globals")
onready var globals = get_node("/root/Globals")

const first_ladder_wood = 10
const second_ladder_wood = 15

var player_in_water = false


var damage_timer = 0.0
var damage_interval = 3.0




func _process(delta):
	if player_in_water:
		damage_timer += delta
		
		if damage_timer >= damage_interval:
			damage_timer = 0.0
			globals.Health -= 1
	
func _ready():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()

	var centered_position = (screen_size - window_size) / 2
	global_vars.next_scene = "res://LevelScenes/Level 3.tscn"
	OS.set_window_position(centered_position)
	#hide both ladders
	ladder1.visible = false
	ladder2.visible = false
	
	if !globals.is_connected("wood_changed", self, "_on_wood_changed"):
		globals.connect("wood_changed", self, "_on_wood_changed")
		
	_on_wood_changed(globals.Wood)
	
		

func _on_wood_changed(amount):
	#first seciton appears
	if amount >= first_ladder_wood:
		build_ladder()
		
	if amount >= second_ladder_wood:
		build_ladder2()
	

 
func build_ladder():
	if !ladder1.visible:
		#sfx ladder building
		ladder1.visible = true

func build_ladder2():
	if !ladder2.visible:
		#sfx buildladder2
		ladder2.visible = true
	


func _on_waterDamageArea_body_entered(body):
	if body.name == "Player":
		player_in_water = true
		#SFX WATER
		damage_timer =0.0


func _on_waterDamageArea_body_exited(body):
	if body.name == "Player":
		player_in_water = false
		damage_timer=0.0
