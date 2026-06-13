extends KinematicBody2D

#const UP = Vector2(0, -1)
const SPEED = 200
#const GRAVITY = 20
#const JUMP_HEIGHT = -600

var motion = Vector2()
var altair = "Player"
enum{
	IDLE,
	ATTACK,
	HURT,
	DEAD
}
	
var state = IDLE

var player = null
var player_detected = false
var player_in_attack_range = false
var facing = "front"

onready var sprite = $AnimatedSprite




func _on_AnimatedSprite_animation_finished():
	if state == ATTACK:
		state = IDLE





func _on_DetectArea_body_entered(body):
	if body.name == altair:
		player = body
		player_detected = true
		

func _on_DetectArea_body_exited(body):
	if body.name == altair:
		player_detected = false
		player_in_attack_range = false
		player =  null
		state = IDLE
	


func _on_AttackRange_body_entered(body):
	if body.name == altair:
		print(body.name)
		player_in_attack_range = true


func _on_AttackRange_body_exited(body):
	if body.name == altair:
		player_in_attack_range = false
		

func _process(delta):
	
	if state == DEAD:
		return
	
	if player_detected and player:
		face_player()
		
		if player_in_attack_range:
			state = ATTACK
		else:
			state = IDLE
	else:
		state = IDLE
		
	update_animation()
	
func face_player():
	var dir = player.global_position - global_position
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			facing = "right"
		else:
			facing = "left"
	else:
		if dir.y > 0:
			facing = "front"
		else:
			facing = "back"


func update_animation():

	match state:
		IDLE:
			match facing:
				"left":
					sprite.play("l_idle")
				"right":
					sprite.play("r_idle")
				"front":
					sprite.play("f_idle")
				"back":
					sprite.play("b_idle")

		ATTACK:
			match facing:
				"left":
					sprite.play("l_attack")
				"right":
					sprite.play("r_attack")
				"front":
					print(state)
					sprite.play("f_attack")
				"back":
					sprite.play("b_attack")

		HURT:
			match facing:
				"left":
					sprite.play("l_hurt")
				"right":
					sprite.play("r_hurt")
				"front":
					sprite.play("f_hurt")
				"back":
					sprite.play("b_hurt")

		DEAD:
			match facing:
				"left":
					sprite.play("l_die")
				"right":
					sprite.play("r_die")
				"front":
					sprite.play("f_die")
				"back":
					sprite.play("b_die")
		

