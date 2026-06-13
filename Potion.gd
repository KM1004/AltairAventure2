extends Area2D

onready var global_vars = get_node("/root/Globals")
var picked = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Potion_body_entered(body):
	if picked:
		return
		
	if body.name == "Player":
		picked = true
		
		global_vars.Potions += 1
		
		queue_free()
