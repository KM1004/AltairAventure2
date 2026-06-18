extends KinematicBody2D
onready var global_vars = get_node("/root/Globals")
var can_attack = true
export var attack_cooldown = 1.0   # seconds
export var attack_damage = 5
var CoinScene = preload("res://Coin.tscn")
var PotionScene = preload("res://Potion.tscn")
# ------------------------
# STATE SYSTEM
# ------------------------
enum {
	IDLE,
	RUN,
	ATTACK,
	HURT,
	DEAD,
	WALK
}

var state = IDLE


# ------------------------
# MOVEMENT
# ------------------------
export var run_speed = 100
export var walk_speed = 75
export var patrol_speed = 100
export var gravity = 1000
export var attack_range = 50

var velocity = Vector2.ZERO
var direction = Vector2.RIGHT
var path = []


# ------------------------
# PLAYER
# ------------------------
var player = null
var player_in_range = false
var player_in_attack_range = false


# ------------------------
# STATUS
# ------------------------
var is_dead = false
export var energy = 15


# ------------------------
# NODES
# ------------------------
onready var sprite = $AnimatedSprite
onready var nav = get_parent().get_parent().get_node("Navigation2D")


# =========================================================
# PHYSICS LOOP
# =========================================================
func _physics_process(delta):

	if state == DEAD:
		return

	if player_in_range and player:
		face_player()

		if player_in_attack_range:
			state = ATTACK
		else:
			state = RUN
			chase_player()
	else:
		state = WALK
		patrol()

	velocity = move_and_slide(velocity)
	update_animation()


	if player_in_range and player:
		face_player()

	if player_in_attack_range:
		velocity = Vector2.ZERO   # stop moving
		
		if can_attack:
			state = ATTACK
			attack()
	else:
		state = RUN
		chase_player()


func attack():
	can_attack = false
	
	# Deal damage ONCE
	if player:
		$attack.play()
		global_vars.Health -= attack_damage
		MainHud.update_health(global_vars.Health)

	# Wait before next attack (prevents spam)
	yield(get_tree().create_timer(attack_cooldown), "timeout")
	
	can_attack = true

# =========================================================
# PATROL
# =========================================================
func patrol():
	velocity = direction * walk_speed
	update_facing(direction)


# =========================================================
# CHASE PLAYER (NAVIGATION)
# =========================================================
func chase_player():

	if player == null:
		return

	path = nav.get_simple_path(global_position, player.global_position)

	if path.size() > 1:
		var dir = (path[1] - global_position).normalized()
		update_facing(dir)
		
		velocity = dir * run_speed

		if global_position.distance_to(path[1]) < 5:
			path.remove(1)


# =========================================================
# FACE PLAYER (for animation direction)
# =========================================================
var facing = "f"

func face_player():
	var dir = player.global_position - global_position

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			facing = "r"
		else:
			facing = "l"
	else:
		if dir.y > 0:
			facing = "f"
		else:
			facing = "b"

func update_facing(dir):

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			facing = "r"
		else:
			facing = "l"
	else:
		if dir.y > 0:
			facing = "f"
		else:
			facing = "b"
# =========================================================
# ANIMATION SYSTEM
# =========================================================
func update_animation():

	match state:

		IDLE:
			sprite.play(facing + "_idle")
		
		WALK:
			sprite.play(facing + "_walk")

		RUN:
			sprite.play(facing + "_run")

		ATTACK:
			sprite.play(facing + "_attack")

		HURT:
			sprite.play(facing + "_hurt")

		DEAD:
			sprite.play(facing + "_die")


# =========================================================
# DETECTION AREAS
# =========================================================
func _on_DetectRange_body_entered(body):
	if body.name == "Player":
		player = body
		player_in_range = true


func _on_DetectRange_body_exited(body):
	if body == player:
		player_in_range = false
		player = null
		state = IDLE


func _on_AttackArea_body_entered(body):
	if body == player:
		player_in_attack_range = true


func _on_AttackArea_body_exited(body):
	if body == player:
		player_in_attack_range = false


# =========================================================
# DAMAGE
# =========================================================
func _on_TakeDamage_body_entered(body):
	print(">>> DETECTED:", body, " NAME:", body.name)
	if body.is_in_group("player_weapon"):
		energy -= 3

		if energy <= 0:
			die()
		else:
			state = HURT


# =========================================================
# DEATH
# =========================================================
func die():
	$die.play()
	state = DEAD
	velocity = Vector2.ZERO
	drop_loot()
	
	
	
func take_damage(amount):
	energy -= amount
	print("ENEMY HIT! Energy:", energy)

	if energy <= 0:
		global_vars.Score += 10
		die()
	else:
		state = HURT

func drop_loot():
	# Random chance
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Always drop coin
	var coin = CoinScene.instance()
	coin.global_position = global_position
	get_parent().add_child(coin)

	# 50% chance to drop potion
	if rng.randi_range(0, 1) == 1:
		var potion = PotionScene.instance()
		potion.global_position = global_position
		get_parent().add_child(potion)


func _on_AnimatedSprite_animation_finished():
	if state == DEAD:
		queue_free()
		
	pass # Replace with function body.
