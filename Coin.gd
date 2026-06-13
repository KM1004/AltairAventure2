extends Area2D
onready var global_vars = get_node("/root/Globals")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Coin_body_entered(body):
	if body.name == "Player":
		global_vars.Health -= 10
		Globals.Coins += 10
		MainHud.update_health(global_vars.Health)
		MainHud.update_coins(global_vars.Coins)
		queue_free()#delete the node
	pass # Replace with function body.
