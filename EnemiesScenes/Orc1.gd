extends KinematicBody2D


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
export var run_speed = 200
export var walk_speed = 75
export var patrol_speed = 100
export var gravity = 1000
export var attack_range = 50
export var points = 10

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
var energy = 15


# ------------------------
# NODES
# ------------------------
onready var sprite = $AnimatedSprite
onready var nav = get_parent().get_node("Navigation2D")


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
	state = DEAD
	velocity = Vector2.ZERO
