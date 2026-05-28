extends Node2D


#onready var player = $Player
#onready var main_camera = $MainCamera



# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#player.died.connect(_on_player_died)
	#player.camera_remote_transform.remote_path = main_camera.get_path()
#	pass # Replace with function body.


#func _on_player_died();
	#print("GameOver")
	#get_tree().create_timer(3).timeout.connect(get_tree().reload_current_scene)
