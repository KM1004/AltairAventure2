extends KinematicBody2D
onready var globals = get_node("/root/Globals")
var player = null
var energy = 2

var speed = 80
var player_in_range = false

export var attack_damage = 2
export var attack_cooldown = 1.0
var can_attack = true


func _ready():
	pass


func _physics_process(delta):

	if energy <= 0:
		$AnimatedSprite.play("death")
		queue_free()
		return

	if player != null:

		var direction = (player.global_position - global_position).normalized()

		move_and_slide(direction * speed)

		# Animations
		if abs(direction.x) > abs(direction.y):
			$AnimatedSprite.play("s_walk")
			$hop.play()
			$AnimatedSprite.flip_h = direction.x < 0
		elif direction.y > 0:
			$AnimatedSprite.play("d_walk")
		else:
			$AnimatedSprite.play("u_walk")


func _on_AttackArea_body_entered(body):
	if body.name == "Player":
		player = body
		#subtract player's lives

# ============================
# PLAYER DETECTION
# ============================

func _on_Player_detector_body_entered(body):
	if body.name == "Player":
		player = body
		player_in_range = true
		print("found the player")


func _on_Player_detector_body_exited(body):
	if body == player:
		player = null
		player_in_range = false


# ============================
# ARROW / SWORD DAMAGE
# ============================

func _on_Area2D_area_entered(area):
	if area.is_in_group("player_group"):
		energy -= 1
		if area.is_in_group("player_arrow"):
			area.queue_free()

	if energy <= 0:
		globals.Score += 5
		$die.play()
		queue_free()
		

func attack():
	if not can_attack:
		return

	can_attack = false

	if player:
		$attack.play()
		globals.Health -= attack_damage
		MainHud.update_health(globals.Health)

	yield(get_tree().create_timer(attack_cooldown), "timeout")

	can_attack = true
