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

var _health = 100
var _coins = 0
var _potions = 5
var artifacts = [false, false, false]  

var Health setget set_Health, get_Health
var Coins setget set_Coins, get_Coins
var Potions setget set_Potions, get_Potions

var potion_cooldown = 5.0
var can_use_potion = true

func _ready():
	Health = 100
	Coins = 0
	Potions = 5


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
