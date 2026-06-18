#extends Node
#onready var global_vars = get_node("/root/Globals")
#
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	get_tree().connect("current_scene_changed", self, "_on_scene_changed")
#	$SubMenu.hide()
#	pause_mode = Node.PAUSE_MODE_PROCESS
#	pass # Replace with function body.
#
#
#func _on_scene_changed(scene):
#	var scene_name = scene.name
#
#	if scene_name == "res://MainMenu.tscn":
#		$HUD.hide()
#		$SubMenu.hide()
#	else:
#		$HUD.show()
#		$SubMenu.hide()  # always reset
#
#func update_health(health):
#	var anim_name = ""
#
#	match health:
#		100:
#			anim_name = "FullHealth"
#		90:
#			anim_name = "90%Health"
#		80:
#			anim_name = "80%Health"
#		70:
#			anim_name = "70%Health"
#		60:
#			anim_name = "60%Health"
#		50:
#			anim_name = "50%Health"
#		40:
#			anim_name = "40%Health"
#		30:
#			anim_name = "30%Health"
#		20:
#			anim_name = "20%Health"
#		10:
#			anim_name = "10%Health"
#		0:
#			anim_name = "NoHealth"
#	$HUD/HealthBar.play(anim_name)
#
#func _on_coins_changed(value):
#	update_coins(value)
#
#func update_coins(amount):
#	$HUD/Coin.text = ": " + str(amount)
#
#func hide_hud():
#	$HUD.visible = false
#	pass
#
#func show_hud():
#	$HUD.visible = true
#	pass
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#
#
#
#
#
#
#func _on_SubMenu_pressed():
#	$SubMenu.visible = !$SubMenu.visible
#	get_tree().paused = $SubMenu.visible
#	pass # Replace with function body.
#
#
#func _on_Quit_pressed():
#	get_tree().paused = false
#	get_tree().change_scene("res://MainMenu.tscn")
#	pass # Replace with function body.
#
#
#func _on_Continue_pressed():
#	$SubMenu.hide()
#	get_tree().paused = false
#	pass # Replace with function body.


extends Node

onready var global_vars = get_node("/root/Globals")

var last_score = 0
var current_scene_name = ""

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$SubMenu.hide()

	# CONNECT SIGNALS
	global_vars.connect("health_changed", self, "update_health")
	global_vars.connect("coins_changed", self, "_on_coins_changed")
	global_vars.connect("potions_changed", self, "_on_potions_changed")
	global_vars.connect("artifact_collected", self, "_on_artifact_collected")
	global_vars.connect("wood_changed", self,"_on_wood_changed")
	global_vars.connect("score_changed", self, "_on_score_changed")
	
	
	# FORCE INITIAL UPDATE
	update_health(global_vars.Health)
	update_coins(global_vars.Coins)
	update_potions(global_vars.Potions)
	update_wood(global_vars.Wood)
	update_score(global_vars.Score)
	
	$HUD/Artifact1.hide()
	$HUD/Artifact2.hide()
	$HUD/Artifact3.hide()

func _process(delta):
	var scene = get_tree().current_scene
	
	if scene == null:
		return
	
	# Detect scene change
	if scene.name != current_scene_name:
		current_scene_name = scene.name
		_handle_scene_change(scene.name)


func _handle_scene_change(scene_name):
	get_tree().paused = false
	
	var hud = get_node_or_null("HUD")
	var submenu = get_node_or_null("SubMenu")
	
	if scene_name == "MainMenu" or scene_name == "Credits" or scene_name == "Help" or scene_name == "GameOver1" or scene_name == "Shop"or scene_name == "BoatPortal":
		if hud:
			hud.hide()
		if submenu:
			submenu.hide()
	else:
		if hud:
			hud.show()
		if submenu:
			submenu.hide()
	if scene_name == "Level 3":
		$Wood.show()
	else:
		$Wood.hide()

# ========================
# HEALTH SYSTEM
# ========================
func update_health(health):
	var anim_name = ""

	match health:
		100:
			anim_name = "FullHealth"
		90:
			anim_name = "90%Health"
		80:
			anim_name = "80%Health"
		70:
			anim_name = "70%Health"
		60:
			anim_name = "60%Health"
		50:
			anim_name = "50%Health"
		40:
			anim_name = "40%Health"
		30:
			anim_name = "30%Health"
		20:
			anim_name = "20%Health"
		10:
			anim_name = "10%Health"
		0:
			anim_name = "NoHealth"

	$HUD/HealthBar.play(anim_name)


# ========================
# COIN SYSTEM
# ========================
func _on_coins_changed(value):
	update_coins(value)

func update_coins(amount):
	$HUD/Coin.text = "Coins: " + str(amount)
	
# ========================
# POTION SYSTEM
# ========================
func _on_potions_changed(value):
	print("HUD POTIONS UPDATED:", value)
	update_potions(value)

func update_potions(amount):
	if has_node("HUD/Potion"):
		$HUD/Potion.text = "Potions: " + str(amount)

# ========================
# ARTIFACT SYSTEM
# ========================
func _on_artifact_collected(id):
	match id:
		0:
			$HUD/Artifact1.show()
		1:
			$HUD/Artifact2.show()
		2:
			$HUD/Artifact3.show()

# ========================
# HUD VISIBILITY
# ========================
func hide_hud():
	$HUD.visible = false

func show_hud():
	$HUD.visible = true


# ========================
# SUBMENU / PAUSE
# ========================
func _on_SubMenu_pressed():
	$SubMenu.visible = !$SubMenu.visible
	get_tree().paused = $SubMenu.visible


func _on_Quit_pressed():
	get_tree().paused = false
	var g = get_node("/root/Globals")
	g.save_game()
	get_tree().change_scene("res://MainMenu.tscn")


func _on_Continue_pressed():
	$SubMenu.hide()
	get_tree().paused = false
	

# ========================
# SCORE SYSTEM
# ========================
func _on_score_changed(value):
	if value > last_score:
		$scoreUp.play()
	update_score(value)

func update_score(point):
	var points = ""
	#if has_node("HUD/Score"):
	#	$HUD/Score.text = "Score: " + str(amount)

	if point < 20:
		points = "range1"
	elif point < 40:
		points = "range2"
	elif point < 60:
		points = "range3"
	elif point < 80:
		points = "range4"
	else:
		point = "range5"
	
	$HUD/ScoreBar.play(points)
	
		
		


# ========================
# WOOD SYSTEM
# ========================

func _on_wood_changed(value):
	update_wood(value)

func update_wood(amount):
	if has_node("Wood/woodLabel"):
		$Wood/woodLabel.text = str(amount)

