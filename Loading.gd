extends Control

onready var g = get_node("/root/Globals")

func _ready():
	$Label.text = "Loading..."
	$Description.text = g.loading_text
	$Description.align = Label.ALIGN_CENTER
	$Description.valign = Label.VALIGN_CENTER
	
	load_next_scene()


func load_next_scene():
	yield(get_tree().create_timer(1.0), "timeout") # fake delay (optional)

	get_tree().change_scene(g.next_scene)
