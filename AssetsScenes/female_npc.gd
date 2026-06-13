extends Area2D

export var message: String = "default message"
onready var panel = $Panel


func _ready():
	$Panel/Msg.text = message
	panel.modulate.a =0
	
	MainHud.hide_hud()
	
	pass
	
func show_panel():
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(
		panel, "modulate:a",
		0, 0.6,          # from transparent → visible
		0.5,           # duration (seconds) 
		Tween.TRANS_QUART,#animations
		Tween.EASE_IN_OUT
	)
	
	tween.start()
	pass


func hide_panel():
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(
		panel, "modulate:a",
		panel.modulate.a, 0,
		0.5,
		Tween.TRANS_QUART,
		Tween.EASE_IN_OUT
	)
	
	tween.start()
	pass




func _on_female_nps_body_entered(body):
	if body.name == "Player":
		show_panel()
	pass # Replace with function body.


func _on_female_nps_body_exited(body):
	if body.name == "Player":
		hide_panel()
	pass # Replace with function body.
