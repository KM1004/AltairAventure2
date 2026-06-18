#extends Node
#
#
#onready var Health setget set_Health, get_Health
#onready var Coins setget set_Coins, get_Coins
#
#
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	Health = 100
#	Coins = 0
#	pass # Replace with function body.
#
#func set_Health(value):
#	Health = value
#	pass
#
#func get_Health():
#	return Health
#	pass
#
#func set_Coins(value):
#	Coins = value
#	pass
#
#func get_Coins():
#	return Coins
#	pass
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#
#




extends Node

signal health_changed(new_health)
signal coins_changed(new_coins)
signal potions_changed(new_amount)
signal artifact_collected(id)
signal wood_changed(new_wood)
signal score_changed(new_score)

var player = null
var _health = 100
var _coins = 0
var _potions = 5
var artifacts = [false, false, false]  
var potion_heal_amount = 10
var slash_damage = 3
var arrow_damage = 3
var potion_cost = 10
var slash_cost = 20
var arrow_cost = 20
var potion_upgrade_cost = 100
var _wood = 0
var _score = 0

var Health setget set_Health, get_Health
var Coins setget set_Coins, get_Coins
var next_scene = ""
var Potions setget set_Potions, get_Potions
var Wood setget set_wood, get_wood
var Score setget set_score, get_score

var potion_cooldown = 5.0
var can_use_potion = true
var next_spawn_position = Vector2.ZERO
var portal_from_scene = ""
var portal_spawn_position = Vector2.ZERO
var loading_text = ""
var save_data = {}

func _ready():
	Health = 100
	Coins = 0
	Potions = 5
	Wood = 0
	Score = 0

func reset_globals():
	_health = 100
	_coins = 0
	_potions = 5
	_wood = 0
	_score = 0
	next_spawn_position = Vector2.ZERO
	
	emit_signal("health_changed", _health)
	emit_signal("coins_changed", _coins)
	emit_signal("potions_changed", _potions)


# ========================
# HEALTH
# ========================

func set_Health(value):
	_health = clamp(value, 0, 100)
	emit_signal("health_changed", _health)

func get_Health():
	return _health


# ========================
# COINS
# ========================

func set_Coins(value):
	_coins = max(value, 0)
	emit_signal("coins_changed", _coins)

func get_Coins():
	return _coins
	

# ========================
# POTIONS
# ========================

func set_Potions(value):
	_potions = max(value, 0)
	emit_signal("potions_changed", _potions)

func get_Potions():
	return _potions


# ========================
# USE POTION
# ========================

#func use_potion():
#	if _potions > 0 and can_use_potion:
#		Potions -= 1
#		Health += 10
#
#		can_use_potion = false
#		start_cooldown()

#func use_potion():
#	print("POTION FUNCTION RUNNING")
#	print("Before:", _potions, _health)
#
#	if _potions > 0 and can_use_potion:
#		Potions -= 1
#		Health += 10
#
#		print("After:", _potions, _health)
#
#		can_use_potion = false
#		start_cooldown()

func use_potion():
	print("POTION FUNCTION RUNNING")

	# BLOCK if no potions
	if _potions <= 0:
		print("No potions")
		return

	# BLOCK if on cooldown
	if not can_use_potion:
		print("On cooldown")
		return

	# 🚫 BLOCK if already full health
	if _health >= 100:
		print("Health already full")
		return

	print("Before:", _potions, _health)

	# USE potion
	_potions -= 1
	set_Potions(_potions)

	# HEAL but clamp to 100
	_health += 10
	_health = clamp(_health, 0, 100)
	set_Health(_health)

	print("After:", _potions, _health)

	# START cooldown
	can_use_potion = false
	start_cooldown()


func start_cooldown():
	yield(get_tree().create_timer(potion_cooldown), "timeout")
	can_use_potion = true
	

func collect_artifact(id):
	if id >= 0 and id < artifacts.size():
		if artifacts[id] == false:
			artifacts[id] = true
			emit_signal("artifact_collected", id)

# ========================
# SCORE
# ========================
func set_score(value):
	_score = max(value, 0)
	emit_signal("score_changed", _score)

func get_score():
	return _score

func add_score(amount):
	set_score(_score + amount)



# ========================
# LEVEL 3 wood collection 
# ========================

func set_wood(value):
	_wood = max(value,0)
	emit_signal("wood_changed", _wood)
	

func get_wood():
	return _wood


func add_wood(amount):
	set_wood(Wood + amount)

func save_game():
	var player = self.player
	
	# 🔥 fallback if not assigned
	if player == null:
		player = get_tree().get_root().find_node("Player", true, false)
	
	# ❌ STILL NULL → STOP
	if player == null:
		print("ERROR: Player not found, cannot save")
		return
	
	save_data = {
		"scene": get_tree().current_scene.filename,
		"player_x": player.global_position.x,
		"player_y": player.global_position.y,
		"coins": Coins,
		"potions": Potions,
		"slash_damage": slash_damage,
		"arrow_damage": arrow_damage,
		"potion_heal": potion_heal_amount
	}
	
	var file = File.new()
	file.open("user://save.dat", File.WRITE)
	file.store_var(save_data)
	file.close()

func load_game():
	var file = File.new()
	
	if not file.file_exists("user://save.dat"):
		return false
	
	file.open("user://save.dat", File.READ)
	save_data = file.get_var()
	file.close()
	
	return true

func apply_save():
	get_tree().change_scene(save_data["scene"])
	
	yield(get_tree(), "idle_frame")  # wait 1 frame
	yield(get_tree(), "idle_frame")  # 🔥 wait extra (important)

	var player = get_tree().get_root().find_node("Player", true, false)
	
	if player == null:
		print("ERROR: Player not found after loading")
		return
	
	player.position = Vector2(
		save_data["player_x"],
		save_data["player_y"]
	)
	
	Coins = save_data["coins"]
	Potions = save_data["potions"]
	slash_damage = save_data["slash_damage"]
	arrow_damage = save_data["arrow_damage"]
	potion_heal_amount = save_data["potion_heal"]
